import Flutter
import Foundation

/// Class that implements On-Demand Resource for iOS
class OnDemandResourcesPigeon: NSObject, OnDemandResourcesHostApiMethods {

    private let logTag = "OnDemandResourcesPigeon"

    private let progressKeyPath = "fractionCompleted"

    // Map holding resource requests
    private var resourceRequests: [String: NSBundleResourceRequest] = [:]

    // Sink for stream
    private var eventSink: PigeonEventSink<IOSOnDemandResourcePigeon>? = nil

    // Singleton
    static let shared = OnDemandResourcesPigeon()

    private override init() {
        super.init()
    }

    func onListen(withArguments arguments: Any?, sink: PigeonEventSink<IOSOnDemandResourcePigeon>) {
        eventSink = sink
    }

    func onCancel(withArguments arguments: Any?) {
        eventSink = nil
    }

    // KVO Callback
    override func observeValue(
        forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        switch keyPath {
        case progressKeyPath:
            guard let progress = object as? Progress else {
                return
            }

            // Find the corresponding tag
            for (tag, request) in resourceRequests where request.progress == progress {
                let resource = IOSOnDemandResourcePigeon.fromIOS(
                    tag: tag, request: request, overrideProgress: progress)
                // Send progress information
                eventSink?.success(resource)
            }
            break
        default:
            break
        }
    }

    /// Obtains NSBundleResourceRequest information for the specified tag.
    func requestNSBundleResourceRequests(tags: [String]) throws -> IOSOnDemandResourcesPigeon {
        var resourceMap: [String: IOSOnDemandResourcePigeon] = [:]
        for tag in tags {
            if resourceRequests[tag] == nil {
                let request = NSBundleResourceRequest(tags: [tag])
                resourceRequests[tag] = request
            }

            let request = resourceRequests[tag]!
            // Set up progress monitoring
            request.progress.addObserver(
                self, forKeyPath: progressKeyPath, options: [.new], context: nil)
            let resource = IOSOnDemandResourcePigeon.fromIOS(tag: tag, request: request)
            resourceMap[tag] = resource
        }

        let response = IOSOnDemandResourcesPigeon(resourceMap: resourceMap)
        return response
    }

    /// Starts downloading the resource for the specified tag
    func beginAccessingResources(
        tags: [String], completion: @escaping (Result<IOSOnDemandResourcesPigeon, Error>) -> Void
    ) {
        // Returns an error if the value contained in tags does not exist in requestsToFetch
        guard tags.allSatisfy(resourceRequests.keys.contains) else {
            completion(
                .failure(
                    PigeonError(
                        code: "-1",
                        message:
                            "[\(logTag)] All tags must be called in requestNSBundleResourceRequests().",
                        details: "tags: \(tags), resourceRequests.keys: \(resourceRequests.keys)")))
            return
        }

        // Filter down resources to fetch
        let requestsToFetch = resourceRequests.filter { tags.contains($0.key) }

        // DispatchGroup to wait for completion of all resource accesses
        let group = DispatchGroup()

        // Map to store results
        var resourceMap: [String: IOSOnDemandResourcePigeon] = [:]

        for (tag, request) in requestsToFetch {
            group.enter()

            // Downloaded or not
            request.conditionallyBeginAccessingResources { (condition) in
                if condition {
                    let resource = IOSOnDemandResourcePigeon.fromIOS(
                        tag: tag, request: request, condition: condition)

                    resourceMap[tag] = resource

                    group.leave()
                } else {
                    // ダウンロード開始
                    request.beginAccessingResources { (error) in
                        defer { group.leave() }

                        if let error = error as? NSError {
                            let resource = IOSOnDemandResourcePigeon.fromIOS(
                                tag: tag, request: request, error: error, condition: condition)

                            resourceMap[tag] = resource
                        } else {
                            let resource = IOSOnDemandResourcePigeon.fromIOS(
                                tag: tag, request: request, condition: condition)

                            resourceMap[tag] = resource
                        }
                    }
                }
            }
        }

        // Call completion when all resource access processing is complete
        group.notify(queue: .main) {
            let response = IOSOnDemandResourcesPigeon(resourceMap: resourceMap)
            completion(.success(response))
        }
    }

    /// Get the absolute path of the asset
    func getAbsoluteAssetPath(tag: String, relativeAssetPath: String) throws -> String? {
        guard let request = resourceRequests[tag] else {
            return nil
        }

        // Check if the resource is accessible
        if request.progress.isFinished {
            // ODR resources are located in ODR-related directories in Bundle.main
            if let resourceURL = Bundle.main.url(forResource: relativeAssetPath, withExtension: nil)
            {
                return resourceURL.path
            }

            // Try to get the extension
            let components = relativeAssetPath.components(separatedBy: ".")
            if components.count > 1 {
                let name = components.dropLast().joined(separator: ".")
                let ext = components.last
                if let resourceURL = Bundle.main.url(forResource: name, withExtension: ext) {
                    return resourceURL.path
                }
            }
        }

        return nil
    }
}

/// StreamHandler implementation
class OnDemandResourcePigeonStreamHandler: StreamOnDemandResourceStreamHandler {
    override func onListen(
        withArguments arguments: Any?, sink: PigeonEventSink<IOSOnDemandResourcePigeon>
    ) {
        OnDemandResourcesPigeon.shared.onListen(withArguments: arguments, sink: sink)
    }

    override func onCancel(withArguments arguments: Any?) {
        OnDemandResourcesPigeon.shared.onCancel(withArguments: arguments)
    }
}

// Type conversion to Pigeon

extension IOSOnDemandResourcePigeon {
    static func fromIOS(
        tag: String, request: NSBundleResourceRequest, overrideProgress: Progress? = nil,
        error: Error? = nil, condition: Bool? = nil
    ) -> IOSOnDemandResourcePigeon {
        let progress = overrideProgress ?? request.progress
        return IOSOnDemandResourcePigeon(
            tag: tag,
            error: nil,
            condition: condition ?? false,
            loadingPriority: request.loadingPriority,
            progress: IOSProgressPigeon(
                isCancelled: progress.isCancelled,
                isPaused: progress.isPaused,
                fractionCompleted: progress.fractionCompleted,
                isFinished: progress.isFinished
            )
        )
    }
}
