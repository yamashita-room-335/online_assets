import Flutter
import Foundation

/// Class that implements On-Demand Resource Stream for iOS
class OnDemandResourcesStreamHandler: StreamOnDemandResourceStreamHandler {

    private static let LOG_TAG = "OnDemandResourcesStreamHandler"

    // Singleton
    static let shared = OnDemandResourcesStreamHandler()

    private override init() {
        super.init()
    }

    var eventSink: PigeonEventSink<IOSOnDemandResourcePigeon>? = nil

    override func onListen(
        withArguments arguments: Any?, sink: PigeonEventSink<IOSOnDemandResourcePigeon>
    ) {
        print(
            "\(OnDemandResourcesStreamHandler.LOG_TAG) [onListen(arguments: \(String(describing: arguments)), sink: \(sink))]"
        )
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
        print(
            "\(OnDemandResourcesStreamHandler.LOG_TAG) [onCancel(arguments: \(String(describing: arguments)))]"
        )
        eventSink = nil
    }
}

/// Class that implements On-Demand Resource API for iOS
class OnDemandResourcesApiImplementation: NSObject, OnDemandResourcesHostApiMethods {

    private static let LOG_TAG = "OnDemandResourcesApiImplementation"

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
        print(
            "\(OnDemandResourcesApiImplementation.LOG_TAG) [observeValue(keyPath: \(String(describing: keyPath)), of: \(String(describing: object)), change: \(String(describing: change)), context: \(String(describing: context)))] start"
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
                OnDemandResourcesStreamHandler.shared.sendEvent(event: resource)
            }
            break
        default:
            break
        }
    }

    /// Obtains NSBundleResourceRequest information for the specified tag.
    func requestNSBundleResourceRequests(tags: [String]) throws -> IOSOnDemandResourcesPigeon {
        print(
            "\(OnDemandResourcesApiImplementation.LOG_TAG) [requestNSBundleResourceRequests(tags: \(tags))] start"
        )
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
        print(
            "\(OnDemandResourcesApiImplementation.LOG_TAG) [requestNSBundleResourceRequests(tags: \(tags))] response: \(response)"
        )
        return response
    }

    /// Starts downloading the resource for the specified tag
    func beginAccessingResources(
        tags: [String], completion: @escaping (Result<IOSOnDemandResourcesPigeon, Error>) -> Void
    ) {
        print(
            "\(OnDemandResourcesApiImplementation.LOG_TAG) [beginAccessingResources(tags: \(tags))] start"
        )
        // Returns an error if the value contained in tags does not exist in requestsToFetch
        guard tags.allSatisfy(resourceRequests.keys.contains) else {
            completion(
                .failure(
                    PigeonError(
                        code: "-1",
                        message:
                            "\(OnDemandResourcesApiImplementation.LOG_TAG) [beginAccessingResources(tags: \(tags))] All tags must be called in requestNSBundleResourceRequests().",
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
            print(
                "\(OnDemandResourcesApiImplementation.LOG_TAG) [requestNSBundleResourceRequests(tags: \(tags))] conditionallyBeginAccessingResources"
            )
            request.conditionallyBeginAccessingResources { (condition) in
                print(
                    "\(OnDemandResourcesApiImplementation.LOG_TAG) [requestNSBundleResourceRequests(tags: \(tags))] beginAccessingResources condition: \(condition)"
                )
                if condition {
                    print(
                        "\(OnDemandResourcesApiImplementation.LOG_TAG) [requestNSBundleResourceRequests(tags: \(tags))] existing resource"
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
                    print(
                        "\(OnDemandResourcesApiImplementation.LOG_TAG) [requestNSBundleResourceRequests(tags: \(tags))] request.beginAccessingResources start"
                    )
                    request.beginAccessingResources { (error) in
                        defer { group.leave() }

                        if let error = error as? NSError {
                            print(
                                "\(OnDemandResourcesApiImplementation.LOG_TAG) [requestNSBundleResourceRequests(tags: \(tags))] beginAccessingResources error: \(error)"
                            )
                            let resource = IOSOnDemandResourcePigeon.fromIOS(
                                tag: tag, request: request, error: error, condition: condition)

                            resourceMap[tag] = resource
                        } else {
                            print(
                                "\(OnDemandResourcesApiImplementation.LOG_TAG) [requestNSBundleResourceRequests(tags: \(tags))] download finish tag: \(tag)"
                            )
                            let resource = IOSOnDemandResourcePigeon.fromIOS(
                                tag: tag, request: request, condition: condition)

                            resourceMap[tag] = resource
                        }
                    }
                } else {
                    print(
                        "\(OnDemandResourcesApiImplementation.LOG_TAG) [requestNSBundleResourceRequests(tags: \(tags))] before call request.beginAccessingResources. Nothing to do"
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
            print(
                "\(OnDemandResourcesApiImplementation.LOG_TAG) [requestNSBundleResourceRequests(tags: \(tags))] notify"
            )
            let response = IOSOnDemandResourcesPigeon(resourceMap: resourceMap)
            completion(.success(response))
        }
    }

    /// Get the absolute path of the asset
    func getAbsoluteAssetPath(
        tag: String, relativeAssetPathWithTagNamespace: String, extensionLevel: Int64
    ) throws -> String? {
        print(
            "\(OnDemandResourcesApiImplementation.LOG_TAG) [getAbsoluteAssetPath(tag: \(tag), relativeAssetPathWithTagNamespace: \(relativeAssetPathWithTagNamespace))] start"
        )
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
        print(
            "\(OnDemandResourcesApiImplementation.LOG_TAG) [getAbsoluteAssetPath(tag: \(tag), relativeAssetPathWithTagNamespace: \(relativeAssetPathWithTagNamespace))] targetFolderURL: \(targetFolderURL), fileName: \(fileName)"
        )

        do {
            try fileManager.createDirectory(
                at: targetFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(
                "\(OnDemandResourcesApiImplementation.LOG_TAG) [getAbsoluteAssetPath(tag: \(tag), relativeAssetPathWithTagNamespace: \(relativeAssetPathWithTagNamespace))] fileManager.createDirectory error: \(error)"
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
        print(
            "\(OnDemandResourcesApiImplementation.LOG_TAG) [getAbsoluteAssetPath(tag: \(tag), relativeAssetPathWithTagNamespace: \(relativeAssetPathWithTagNamespace))] targetURL: \(targetURL), named: \(name)"
        )
        if isImageFile, let image = UIImage(named: name) {
            if let imageData = image.pngData() {
                do {
                    print(
                        "\(OnDemandResourcesApiImplementation.LOG_TAG) [getAbsoluteAssetPath(tag: \(tag), relativeAssetPathWithTagNamespace: \(relativeAssetPathWithTagNamespace))] image: \(image), targetURL: \(targetURL)"
                    )
                    if !fileManager.fileExists(atPath: targetURL.path) {
                        print(
                            "\(OnDemandResourcesApiImplementation.LOG_TAG) [getAbsoluteAssetPath(tag: \(tag), relativeAssetPathWithTagNamespace: \(relativeAssetPathWithTagNamespace))] imageData.write(to: \(targetURL))"
                        )
                        try imageData.write(to: targetURL)
                    }
                    return targetURL.path
                } catch {
                    print(
                        "\(OnDemandResourcesApiImplementation.LOG_TAG) [getAbsoluteAssetPath(tag: \(tag), relativeAssetPathWithTagNamespace: \(relativeAssetPathWithTagNamespace))] imageData.write error: \(error)"
                    )
                    return nil
                }
            }
        } else if let asset = NSDataAsset(name: name) {
            do {
                print(
                    "\(OnDemandResourcesApiImplementation.LOG_TAG) [getAbsoluteAssetPath(tag: \(tag), relativeAssetPathWithTagNamespace: \(relativeAssetPathWithTagNamespace))] asset: \(asset), targetURL: \(targetURL)"
                )
                if !fileManager.fileExists(atPath: targetURL.path) {
                    print(
                        "\(OnDemandResourcesApiImplementation.LOG_TAG) [getAbsoluteAssetPath(tag: \(tag), relativeAssetPathWithTagNamespace: \(relativeAssetPathWithTagNamespace))] asset.data.write(to: \(targetURL))"
                    )
                    try asset.data.write(to: targetURL)
                }
                return targetURL.path
            } catch {
                print(
                    "\(OnDemandResourcesApiImplementation.LOG_TAG) [getAbsoluteAssetPath(tag: \(tag), relativeAssetPathWithTagNamespace: \(relativeAssetPathWithTagNamespace))] asset.data.write error: \(error)"
                )
                return nil
            }
        } else {
            print(
                "\(OnDemandResourcesApiImplementation.LOG_TAG) [getAbsoluteAssetPath(tag: \(tag), relativeAssetPathWithTagNamespace: \(relativeAssetPathWithTagNamespace))] Can not load asset."
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
