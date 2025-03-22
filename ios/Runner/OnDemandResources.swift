import Flutter
import Foundation

/// Class that implements On-Demand Resource Stream for iOS
class OnDemandResourcesStreamHandler: StreamOnDemandResourceStreamHandler {

    private static let LOG_TAG = "OnDemandResourcesStreamHandler"

    private func log(_ message: String) {
        print("\(OnDemandResourcesStreamHandler.LOG_TAG) \(message)", terminator: "\n\n")
    }

    // Singleton
    static let shared = OnDemandResourcesStreamHandler()

    private override init() {
        super.init()
    }

    var eventSink: PigeonEventSink<IOSOnDemandResourcePigeon>? = nil

    override func onListen(
        withArguments arguments: Any?, sink: PigeonEventSink<IOSOnDemandResourcePigeon>
    ) {
        let methodInfo = "[onListen(arguments: \(String(describing: arguments)), sink: \(sink))]"
        log("\(methodInfo) start")

        eventSink = sink
    }

    func sendEvent(event: IOSOnDemandResourcePigeon) {
        DispatchQueue.main.async {
            if let eventSink = self.eventSink {
                eventSink.success(event)
            }
        }
    }

    override func onCancel(withArguments arguments: Any?) {
        let methodInfo = "[onCancel(arguments: \(String(describing: arguments)))]"
        log("\(methodInfo) start")

        eventSink = nil
    }
}

/// Class that implements On-Demand Resource API for iOS
class OnDemandResourcesApiImplementation: NSObject, OnDemandResourcesHostApiMethods {

    private static let LOG_TAG = "OnDemandResourcesApiImplementation"

    private func log(_ message: String) {
        print("\(OnDemandResourcesApiImplementation.LOG_TAG) \(message)", terminator: "\n\n")
    }

    private let progressKeyPath = "fractionCompleted"

    // Map holding resource requests
    // Multiple calls to beginAccessingResources() on the same NSBundleResourceRequest will result in an exception.
    // Therefore, calls to beginAccessingResources() should be held as true.
    private var resourceRequests: [String: (NSBundleResourceRequest, Bool)] = [:]

    // KVO Callback
    override func observeValue(
        forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        let methodInfo =
            "[observeValue(keyPath: \(String(describing: keyPath)), of: \(String(describing: object)), change: \(String(describing: change)), context: \(String(describing: context)))]"
        log("\(methodInfo) start")

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
                OnDemandResourcesStreamHandler.shared.sendEvent(event: resource)
            }
            break
        default:
            break
        }
    }

    /// Obtains NSBundleResourceRequest information for the specified tag.
    func requestNSBundleResourceRequests(tags: [String]) throws -> IOSOnDemandResourcesPigeon {
        let methodInfo = "[requestNSBundleResourceRequests(tags: \(tags))]"
        log("\(methodInfo) start")

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
        log("\(methodInfo)  response: \(response)")
        return response
    }

    /// Starts downloading the resource for the specified tag
    func beginAccessingResources(
        tags: [String], completion: @escaping (Result<IOSOnDemandResourcesPigeon, Error>) -> Void
    ) {
        let methodInfo = "[beginAccessingResources(tags: \(tags))]"
        log("\(methodInfo) start")

        // Returns an error if the value contained in tags does not exist in requestsToFetch
        guard tags.allSatisfy(resourceRequests.keys.contains) else {
            completion(
                .failure(
                    PigeonError(
                        code: "-1",
                        message:
                            "\(methodInfo) All tags must be called in requestNSBundleResourceRequests().",
                        details: "")))
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
            log(
                "\(methodInfo) conditionallyBeginAccessingResources"
            )
            request.conditionallyBeginAccessingResources { [weak self] (condition) in
                self?.log(
                    "\(methodInfo) beginAccessingResources condition: \(condition)"
                )
                if condition {
                    self?.log(
                        "\(methodInfo) existing resource"
                    )
                    // The already downloaded Progress is not updated and notified, so it is necessary to set the progress as completed from the code.
                    request.progress.becomeCurrent(withPendingUnitCount: 100)
                    request.progress.resignCurrent()
                    let resource = IOSOnDemandResourcePigeon.fromIOS(
                        tag: tag, request: request, condition: condition)

                    resourceMap[tag] = resource

                    group.leave()
                } else if !calledBeginAccessingResources {
                    // ダウンロード開始
                    self?.log(
                        "\(methodInfo) request.beginAccessingResources start"
                    )
                    request.beginAccessingResources { [weak self] (error) in
                        defer { group.leave() }

                        if let error = error as? NSError {
                            self?.log(
                                "\(methodInfo) beginAccessingResources error: \(error)"
                            )
                            let resource = IOSOnDemandResourcePigeon.fromIOS(
                                tag: tag, request: request, error: error, condition: condition)

                            resourceMap[tag] = resource
                        } else {
                            self?.log(
                                "\(methodInfo) download finish tag: \(tag)"
                            )
                            let resource = IOSOnDemandResourcePigeon.fromIOS(
                                tag: tag, request: request, condition: condition)

                            resourceMap[tag] = resource
                        }
                    }
                } else {
                    self?.log(
                        "\(methodInfo) before call request.beginAccessingResources. Nothing to do"
                    )
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
            let response = IOSOnDemandResourcesPigeon(resourceMap: resourceMap)
            completion(.success(response))
        }
    }

    /// Get the absolute path of the asset
    func getAbsoluteAssetPath(
        tag: String, relativeAssetPathWithTagNamespace: String, extensionLevel: Int64
    ) throws -> String? {
        let methodInfo =
            "[getAbsoluteAssetPath(tag: \(tag), relativeAssetPathWithTagNamespace: \(relativeAssetPathWithTagNamespace))]"
        log("\(methodInfo) start")

        guard let (request, _) = resourceRequests[tag] else {
            return nil
        }

        guard request.progress.isFinished else {
            return nil
        }

        let fileManager = FileManager.default
        var targetFolderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let relativePathComponents = relativeAssetPathWithTagNamespace.components(separatedBy: "/")
        let nestFolders = relativePathComponents.dropLast()
        let fileName = relativePathComponents.last!

        for folderName in nestFolders {
            targetFolderURL = targetFolderURL.appendingPathComponent(folderName)
        }
        log(
            "\(methodInfo) targetFolderURL: \(targetFolderURL), fileName: \(fileName)"
        )

        do {
            try fileManager.createDirectory(
                at: targetFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            log(
                "\(methodInfo) fileManager.createDirectory error: \(error)"
            )
            return nil
        }

        var fileNameWithoutExtension = fileName
        var fileExtension = ""

        let fileNameComponents = fileName.components(separatedBy: ".")
        if fileNameComponents.count > extensionLevel {
            fileNameWithoutExtension = fileNameComponents.dropLast(
                Int(truncatingIfNeeded: extensionLevel)
            )
            .joined(separator: ".")
            fileExtension = fileName.replacingOccurrences(
                of: "\(fileNameWithoutExtension).", with: "")
        }

        // iOS support image format
        let isImageFile =
            switch fileExtension.lowercased() {
            case "tiff", "tif": true
            case "jpg", "jpeg": true
            case "gif": true
            case "png": true
            case "bmp", "bmpf": true
            case "ico": true
            case "cur": true
            case "xbm": true
            default: false
            }

        let targetURL: URL
        if fileExtension.isEmpty {
            targetURL = targetFolderURL.appendingPathComponent("\(fileNameWithoutExtension)")
        } else if isImageFile {
            // To output images as pngData
            targetURL = targetFolderURL.appendingPathComponent(
                "\(fileNameWithoutExtension).png")
        } else {
            targetURL = targetFolderURL.appendingPathComponent(
                "\(fileNameWithoutExtension).\(fileExtension)")
        }

        let name: String
        if nestFolders.isEmpty {
            name = fileNameWithoutExtension
        } else {
            name = "\(nestFolders.joined(separator: "/"))/\(fileNameWithoutExtension)"
        }
        log(
            "\(methodInfo) targetURL: \(targetURL), named: \(name)"
        )
        if isImageFile, let image = UIImage(named: name) {
            if let imageData = image.pngData() {
                do {
                    log(
                        "\(methodInfo) image: \(image), targetURL: \(targetURL)"
                    )
                    if !fileManager.fileExists(atPath: targetURL.path) {
                        log(
                            "\(methodInfo) imageData.write(to: \(targetURL))"
                        )
                        try imageData.write(to: targetURL)
                    }
                    return targetURL.path
                } catch {
                    log(
                        "\(methodInfo) imageData.write error: \(error)"
                    )
                    return nil
                }
            }
        } else if let asset = NSDataAsset(name: name) {
            do {
                log(
                    "\(methodInfo) asset: \(asset), targetURL: \(targetURL)"
                )
                if !fileManager.fileExists(atPath: targetURL.path) {
                    log(
                        "\(methodInfo) asset.data.write(to: \(targetURL))"
                    )
                    try asset.data.write(to: targetURL)
                }
                return targetURL.path
            } catch {
                log(
                    "\(methodInfo) asset.data.write error: \(error)"
                )
                return nil
            }
        } else {
            log(
                "\(methodInfo) Can not load asset."
            )
            return nil
        }

        return nil
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
