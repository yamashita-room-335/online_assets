import Flutter
import Foundation

/// Class that implements On-Demand Resource for iOS
class OnDemandResources: NSObject, OnDemandResourcesHostApiMethods {

    private let logTag = "OnDemandResources"

    private let progressKeyPath = "fractionCompleted"

    // Map holding resource requests
    // Multiple calls to beginAccessingResources() on the same NSBundleResourceRequest will result in an exception.
    // Therefore, calls to beginAccessingResources() should be held as true.
    private var resourceRequests: [String: (NSBundleResourceRequest, Bool)] = [:]

    // Sink for stream
    private var eventSink: PigeonEventSink<IOSOnDemandResourcePigeon>? = nil

    // Singleton
    static let shared = OnDemandResources()

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
        print(
            "observeValue(keyPath: \(String(describing: keyPath)), of: \(String(describing: object)), change: \(String(describing: change)), context: \(String(describing: context)))"
        )
        switch keyPath {
        case progressKeyPath:
            guard let progress = object as? Progress else {
                return
            }

            // Find the corresponding tag
            for (tag, (request, _)) in resourceRequests
            where request.progress == progress {
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
        print("requestNSBundleResourceRequests(tags: \(tags))")
        var resourceMap: [String: IOSOnDemandResourcePigeon] = [:]
        for tag in tags {
            if resourceRequests[tag] == nil {
                let request = NSBundleResourceRequest(tags: [tag], bundle: .main)
                resourceRequests[tag] = (request, false)
            }

            let (request, _) = resourceRequests[tag]!
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
        print("beginAccessingResources(tags: \(tags)) start")
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

        for (tag, (request, calledBeginAccessingResources)) in requestsToFetch {
            // Filter down resources to fetch
            // Create each time because calling beginAccessingResources() multiple times with the same NSBundleResourceRequest will result in an exception.
            if calledBeginAccessingResources {
                continue
            }
            self.resourceRequests[tag] = (request, true)

            group.enter()

            // Downloaded or not
            print("request.conditionallyBeginAccessingResources")
            request.conditionallyBeginAccessingResources { (condition) in
                print("beginAccessingResources tag: \(tag), condition: \(condition)")
                if condition {
                    print("existing resource, tag: \(tag)")
                    let resource = IOSOnDemandResourcePigeon.fromIOS(
                        tag: tag, request: request, condition: condition)

                    resourceMap[tag] = resource

                    group.leave()
                } else if !calledBeginAccessingResources {
                    // ダウンロード開始
                    print("request.beginAccessingResources tag: \(tag) start")
                    request.beginAccessingResources { (error) in
                        defer { group.leave() }

                        if let error = error as? NSError {
                            print("tag: \(tag) error: \(error)")
                            let resource = IOSOnDemandResourcePigeon.fromIOS(
                                tag: tag, request: request, error: error, condition: condition)

                            resourceMap[tag] = resource
                        } else {
                            print("download finish tag: \(tag)")
                            let resource = IOSOnDemandResourcePigeon.fromIOS(
                                tag: tag, request: request, condition: condition)

                            resourceMap[tag] = resource
                        }
                    }
                } else {
                    print("before call request.beginAccessingResources tag: \(tag). Nothing to do")
                    // Nothing to do here because the download is called elsewhere
                    let resource = IOSOnDemandResourcePigeon.fromIOS(
                        tag: tag, request: request, condition: condition)

                    resourceMap[tag] = resource

                    group.leave()
                }
            }
        }

        // Call completion when all resource access processing is complete
        group.notify(queue: .main) {
            print("beginAccessingResources(tags: \(tags)) notify")
            let response = IOSOnDemandResourcesPigeon(resourceMap: resourceMap)
            completion(.success(response))
        }
    }

    /// Get the absolute path of the asset
    func getAbsoluteAssetPath(tag: String, relativeAssetPath: String, extensionLevel: Int64) throws
        -> String?
    {
        print("getAbsoluteAssetPath(tag: \(tag), relativeAssetPath: \(relativeAssetPath))")
        guard let (request, _) = resourceRequests[tag] else {
            return nil
        }
        
        guard request.progress.isFinished else {
            return nil
        }
        
        let fileManager = FileManager.default
        let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        var targetFolderURL = dir.appendingPathComponent(tag)
        let relativePathComponents = relativeAssetPath.components(separatedBy: "/")
        let nestFolders = relativePathComponents.dropLast()
        let fileName = relativePathComponents.last!
        
        for folderName in nestFolders {
            targetFolderURL = targetFolderURL.appendingPathComponent(folderName)
        }
        print("targetFolderURL: \(targetFolderURL), fileName: \(fileName)")

        do {
            try fileManager.createDirectory(
                at: targetFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("fileManager.createDirectory error: \(error)")
            return nil
        }
        
        var fileNameWithoutExtension = fileName
        var fileExtension = ""
        let fileNameComponents = fileName.components(separatedBy: ".")
        if fileNameComponents.count > extensionLevel {
            fileNameWithoutExtension = fileNameComponents.dropLast(Int(truncatingIfNeeded: extensionLevel))
                .joined(separator: ".")
            fileExtension = fileName.replacingOccurrences(of: "\(fileNameWithoutExtension).", with: "")
        }
        
        let targetURL: URL
        if (fileExtension.isEmpty) {
            targetURL = targetFolderURL.appendingPathComponent("\(fileNameWithoutExtension)")
        } else {
            targetURL = targetFolderURL.appendingPathComponent("\(fileNameWithoutExtension).\(fileExtension)")
        }
        
        let named: String
        if (nestFolders.isEmpty) {
            named = fileNameWithoutExtension
        } else {
            named = "\(nestFolders.joined(separator: "/"))/\(fileNameWithoutExtension)"
        }
        print("targetURL: \(targetURL), named: \(named)")
        if let image = UIImage(named: named) {
            if let imageData = image.pngData() {
                do {
                    print("image: \(image), targetURL: \(targetURL)")
                    try imageData.write(to: targetURL)
                    return targetURL.path
                } catch {
                    print("imageData.write error: \(error)")
                    return nil
                }
            }
        } else if let asset = NSDataAsset(name: fileNameWithoutExtension) {
            do {
                print("asset: \(asset), targetURL: \(targetURL)")
                try asset.data.write(to: targetURL)
                return targetURL.path
            } catch {
                print("asset.data.write error: \(error)")
                return nil
            }
        } else {
            print("Can not load asset \(relativeAssetPath) for tag: \(tag)")
            return nil
        }

        return nil
    }
}

/// StreamHandler implementation
class OnDemandResourcePigeonStreamHandler: StreamOnDemandResourceStreamHandler {
    override func onListen(
        withArguments arguments: Any?, sink: PigeonEventSink<IOSOnDemandResourcePigeon>
    ) {
        OnDemandResources.shared.onListen(withArguments: arguments, sink: sink)
    }

    override func onCancel(withArguments arguments: Any?) {
        OnDemandResources.shared.onCancel(withArguments: arguments)
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
