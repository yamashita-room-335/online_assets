import Flutter
import Foundation

// Pigeon Example
// https://github.com/flutter/packages/blob/pigeon-v25.1.0/packages/pigeon/example/app/ios/Runner/AppDelegate.swift

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
class OnDemandResourcesApiImplementation: NSObject, OnDemandResourcesHostApi {

    private static let LOG_TAG = "OnDemandResourcesApiImplementation"

    private func log(_ message: String) {
        print("\(OnDemandResourcesApiImplementation.LOG_TAG) \(message)", terminator: "\n\n")
    }

    private let progressKeyPath = "fractionCompleted"

    // Map holding resource requests
    // Multiple calls to beginAccessingResources() on the same NSBundleResourceRequest will result in an exception.
    // Therefore, calls to beginAccessingResources() should be held as true.
    private var resourceRequests: [String: (NSBundleResourceRequest, Bool)] = [:]

    private var cacheDirectoryURL: URL = FileManager.default.temporaryDirectory
        .appendingPathComponent(
            "odr_cache", isDirectory: true)

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

    func requestResourcesProgress(
        tags: [String], completion: @escaping (Result<IOSOnDemandResourcesPigeon, Error>) -> Void
    ) {
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
        }

        // DispatchGroup to wait for completion of all resource accesses
        let group = DispatchGroup()

        for (tag, (request, _)) in resourceRequests {
            group.enter()

            // Downloaded or not
            log("\(methodInfo) \(tag) conditionallyBeginAccessingResources")
            request.conditionallyBeginAccessingResources { [weak self] (condition) in
                if condition {
                    self?.log("\(methodInfo) \(tag) existing resource")
                    // The already downloaded Progress is not updated and notified, so it is necessary to set the progress as completed from the code.
                    request.progress.becomeCurrent(withPendingUnitCount: 100)
                    request.progress.resignCurrent()
                    let resource = IOSOnDemandResourcePigeon.fromIOS(
                        tag: tag, request: request, condition: condition)

                    resourceMap[tag] = resource
                } else {
                    self?.log("\(methodInfo) \(tag) need to download resource")
                    let resource = IOSOnDemandResourcePigeon.fromIOS(
                        tag: tag, request: request, condition: condition)

                    resourceMap[tag] = resource
                }

                group.leave()
            }
        }

        // Call completion when all resource access processing is complete
        group.notify(queue: .main) {
            let response = IOSOnDemandResourcesPigeon(resourceMap: resourceMap)
            completion(.success(response))
        }
    }

    func beginAccessingResources(
        tags: [String], completion: @escaping (Result<IOSOnDemandResourcesPigeon, Error>) -> Void
    ) {
        let methodInfo = "[beginAccessingResources(tags: \(tags))]"
        log("\(methodInfo) start")

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
            log("\(methodInfo) conditionallyBeginAccessingResources")
            request.conditionallyBeginAccessingResources { [weak self] (condition) in
                self?.log("\(methodInfo) \(tag) beginAccessingResources condition: \(condition)")
                if condition {
                    self?.log("\(methodInfo) \(tag) existing resource")
                    // The already downloaded Progress is not updated and notified, so it is necessary to set the progress as completed from the code.
                    request.progress.becomeCurrent(withPendingUnitCount: 100)
                    request.progress.resignCurrent()
                    let resource = IOSOnDemandResourcePigeon.fromIOS(
                        tag: tag, request: request, condition: condition)

                    resourceMap[tag] = resource

                    group.leave()
                } else if !calledBeginAccessingResources {
                    // ダウンロード開始
                    self?.log("\(methodInfo) \(tag) request.beginAccessingResources start")
                    request.beginAccessingResources { [weak self] (error) in
                        defer { group.leave() }

                        if let error = error as? NSError {
                            self?.log(
                                "\(methodInfo) \(tag) beginAccessingResources error: \(error)")
                            let resource = IOSOnDemandResourcePigeon.fromIOS(
                                tag: tag, request: request, error: error, condition: condition)

                            resourceMap[tag] = resource
                        } else {
                            self?.log("\(methodInfo) \(tag) download finish tag: \(tag)")
                            let resource = IOSOnDemandResourcePigeon.fromIOS(
                                tag: tag, request: request, condition: condition)

                            resourceMap[tag] = resource
                        }
                    }
                } else {
                    self?.log(
                        "\(methodInfo) \(tag) before call request.beginAccessingResources. Nothing to do"
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

    func getCopiedAssetFilePath(
        tag: String?, assetNameWithPackNameNamespace: String, ext: String,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {
        let methodInfo =
            "[getAbsoluteAssetPath(tag: \(tag ?? "nil"), assetNameWithPackNameNamespace: \(assetNameWithPackNameNamespace), ext: \(ext))]"
        log("\(methodInfo) start")

        if let unwrapTag = tag {
            // On-Demand Resources Asset
            if let (request, _) = resourceRequests[unwrapTag] {
                guard request.progress.isFinished else {
                    log(
                        "\(methodInfo) The subject tag's resource has not yet been fully downloaded."
                    )
                    completion(.success(nil))
                    return
                }
            } else {
                completion(
                    .failure(
                        PigeonError(
                            code: "-1",
                            message:
                                "\(methodInfo) Unknown Tag. Please check whether the tag is correct.",
                            details: "")))
                return
            }
        } else {
            // Normal Asset (like Android install-time asset pack)
        }

        let isImageFile = ext.isImageExtension()

        let path: String
        if isImageFile {
            // To output images as pngData
            path = "\(assetNameWithPackNameNamespace).png"
        } else if ext.isEmpty {
            path = "\(assetNameWithPackNameNamespace)"
        } else {
            path = "\(assetNameWithPackNameNamespace)\(ext)"
        }

        let copyFileURL: URL
        if #available(iOS 16.0, *) {
            copyFileURL = cacheDirectoryURL.appending(
                path: path, directoryHint: URL.DirectoryHint.notDirectory)
        } else {
            copyFileURL = cacheDirectoryURL.appendingPathComponent(path, isDirectory: false)
        }

        log("\(methodInfo) copyFileURL: \(copyFileURL)")

        let fileManager = FileManager.default

        // Failure to create a parent folder for the copy destination will result in failure when writing file.
        let parentCopyFolderURL = copyFileURL.deletingLastPathComponent()
        let isNeedCreateParentFolder: Bool
        var isDir: ObjCBool = true
        if fileManager.fileExists(atPath: parentCopyFolderURL.path, isDirectory: &isDir) {
            if isDir.boolValue {
                isNeedCreateParentFolder = false
            } else {
                isNeedCreateParentFolder = true
                log(
                    "\(methodInfo) Delete file with the same path as the target parent folder. \(parentCopyFolderURL.path)"
                )
                do {
                    try fileManager.removeItem(at: parentCopyFolderURL)
                } catch {
                    completion(
                        .failure(
                            PigeonError(
                                code: "-1",
                                message:
                                    "\(methodInfo) error.",
                                details: "\(error)")))
                    return
                }
            }
        } else {
            isNeedCreateParentFolder = true
        }

        if isNeedCreateParentFolder {
            log("\(methodInfo) Create parent folder. \(parentCopyFolderURL.path)")
            do {
                try fileManager.createDirectory(
                    at: parentCopyFolderURL, withIntermediateDirectories: true)
            } catch {
                completion(
                    .failure(
                        PigeonError(
                            code: "-1",
                            message:
                                "\(methodInfo) error.",
                            details: "\(error)")))
                return
            }
        }

        if isImageFile, let image = UIImage(named: assetNameWithPackNameNamespace) {
            if fileManager.fileExists(atPath: copyFileURL.path) {
                // Because of the time required, this function do not check file hash.
                do {
                    let preSavedData = try Data(contentsOf: copyFileURL)
                    let preSavedImage = UIImage(data: preSavedData)
                    if let preImageData = preSavedImage?.cgImage?.dataProvider?.data as? Data,
                        let currentImageData = image.cgImage?.dataProvider?.data as? Data
                    {
                        if preImageData.count == currentImageData.count {
                            log("\(methodInfo) Skip copying, same file size")
                            completion(.success(copyFileURL.path))
                            return
                        }
                    }
                } catch {
                    log("\(methodInfo) try Data(contentsOf: \(copyFileURL)) error: \(error)")
                }
                // Perhaps it may not be a problem to simply overwrite the file without removeItem().
            }

            if let imagePngData = image.pngData() {
                do {
                    log("\(methodInfo) Write pngData to file: \(copyFileURL)")
                    try imagePngData.write(to: copyFileURL, options: [Data.WritingOptions.atomic])
                    completion(.success(copyFileURL.path))
                } catch {
                    completion(
                        .failure(
                            PigeonError(
                                code: "-1",
                                message:
                                    "\(methodInfo) error.",
                                details: "\(error)")))
                }
                return
            }
        }

        if let asset = NSDataAsset(name: assetNameWithPackNameNamespace) {
            if fileManager.fileExists(atPath: copyFileURL.path) {
                // Because of the time required, this function do not check file hash.
                do {
                    let preSavedData = try Data(contentsOf: copyFileURL)
                    if preSavedData.count == asset.data.count {
                        log("\(methodInfo) Skip copying, same file size")
                        completion(.success(copyFileURL.path))
                        return
                    }
                } catch {
                    log("\(methodInfo) try Data(contentsOf: \(copyFileURL)) error: \(error)")
                }
                // Perhaps it may not be a problem to simply overwrite the file without removeItem().
            }

            do {
                log("\(methodInfo) Write NSDataAsset to file: \(copyFileURL)")
                try asset.data.write(to: copyFileURL, options: [Data.WritingOptions.atomic])
                completion(.success(copyFileURL.path))
            } catch {
                completion(
                    .failure(
                        PigeonError(
                            code: "-1",
                            message:
                                "\(methodInfo) error.",
                            details: "\(error)")))
            }
            return
        }

        completion(.success(nil))
    }

    func deleteCopiedAssetFile(
        assetNameWithPackNameNamespace: String, ext: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        let methodInfo =
            "[deleteCopiedAssetFile(assetNameWithPackNameNamespace: \(assetNameWithPackNameNamespace), ext: \(ext))]"
        log("\(methodInfo) start")

        let path: String
        if ext.isImageExtension() {
            // To output images as pngData
            path = "\(assetNameWithPackNameNamespace).png"
        } else if ext.isEmpty {
            path = "\(assetNameWithPackNameNamespace)"
        } else {
            path = "\(assetNameWithPackNameNamespace)\(ext)"
        }

        let copyFileURL: URL
        if #available(iOS 16.0, *) {
            copyFileURL = cacheDirectoryURL.appending(
                path: path,
                directoryHint: URL.DirectoryHint.notDirectory)
        } else {
            copyFileURL = cacheDirectoryURL.appendingPathComponent(
                path, isDirectory: false)
        }

        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: copyFileURL.path) {
            do {
                log("\(methodInfo) Remove copy file")
                try fileManager.removeItem(at: copyFileURL)
            } catch {
                log(
                    "\(methodInfo) ttry fileManager.removeItem(at: \(copyFileURL)) error: \(error)"
                )
                completion(
                    .failure(
                        PigeonError(
                            code: "-1",
                            message:
                                "\(methodInfo) error.",
                            details: "\(error)")))
                return
            }
        }
        completion(.success(true))
    }

    func deleteCopiedAssetFolder(
        packName: String, completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        let methodInfo =
            "[deleteCopiedAssetFile(packName: \(packName))]"
        log("\(methodInfo) start")

        let copyFolderURL: URL
        if #available(iOS 16.0, *) {
            copyFolderURL = cacheDirectoryURL.appending(
                path: "\(packName)", directoryHint: URL.DirectoryHint.isDirectory)
        } else {
            copyFolderURL = cacheDirectoryURL.appendingPathComponent(
                "\(packName)", isDirectory: true)
        }

        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: copyFolderURL.path) {
            do {
                log("\(methodInfo) Remove copy directory")
                try fileManager.removeItem(at: copyFolderURL)
            } catch {
                log(
                    "\(methodInfo) ttry fileManager.removeItem(at: \(copyFolderURL)) error: \(error)"
                )
                completion(
                    .failure(
                        PigeonError(
                            code: "-1",
                            message:
                                "\(methodInfo) error.",
                            details: "\(error)")))
                return
            }
        }
        completion(.success(true))
    }

    func deleteAllCopiedAssetFolders(completion: @escaping (Result<Bool, Error>) -> Void) {
        let methodInfo =
            "[deleteAllCopiedAssetFolders()]"
        log("\(methodInfo) start")

        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: cacheDirectoryURL.path) {
            do {
                log("\(methodInfo) Remove cache directory")
                try fileManager.removeItem(at: cacheDirectoryURL)
            } catch {
                log(
                    "\(methodInfo) ttry fileManager.removeItem(at: \(cacheDirectoryURL)) error: \(error)"
                )
                completion(
                    .failure(
                        PigeonError(
                            code: "-1",
                            message:
                                "\(methodInfo) error.",
                            details: "\(error)")))
                return
            }
        }
        completion(.success(true))
    }
}

extension String {
    func isImageExtension() -> Bool {
        // iOS support image format
        return switch self.lowercased() {
        case ".tiff", ".tif": true
        case ".jpg", ".jpeg": true
        case ".gif": true
        case ".png": true
        case ".bmp", ".bmpf": true
        case ".ico": true
        case ".cur": true
        case ".xbm": true
        default: false
        }
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
