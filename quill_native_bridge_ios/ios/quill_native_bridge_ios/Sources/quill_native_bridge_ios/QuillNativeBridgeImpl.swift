import Foundation
import Flutter
import Photos

class QuillNativeBridgeImpl: QuillNativeBridgeApi {
    func isIosSimulator() throws -> Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
    // TODO: Should not hardcode public.html and instead use UTType.html.identifier
    
    func getClipboardHtml() throws -> String? {
        guard let htmlData = UIPasteboard.general.data(forPasteboardType: "public.html") else {
            return nil
        }
        let html = String(data: htmlData, encoding: .utf8)
        return html
    }
    
    func copyHtmlToClipboard(html: String) throws {
        UIPasteboard.general.setValue(html, forPasteboardType: "public.html")
    }
    
    func copyImageToClipboard(imageBytes: FlutterStandardTypedData) throws {
        guard let image = UIImage(data: imageBytes.data) else {
            throw PigeonError(code: "INVALID_IMAGE", message: "Unable to create UIImage from image bytes.", details: nil)
        }
        UIPasteboard.general.image = image
    }
    
    func getClipboardImage() throws -> FlutterStandardTypedData? {
        let pasteboard = UIPasteboard.general
        if pasteboard.hasImages {
            let image = pasteboard.image
            if let imagePngData = image?.pngData() {
                return FlutterStandardTypedData(bytes: imagePngData)
            }
        }
        if let imageWebpData = pasteboard.data(forPasteboardType: "org.webmproject.webp") {
            return FlutterStandardTypedData(bytes: imageWebpData)
        }
        return nil
    }
    
    func getClipboardGif() throws -> FlutterStandardTypedData? {
        guard let data = UIPasteboard.general.data(forPasteboardType: "com.compuserve.gif") else {
            return nil
        }
        return FlutterStandardTypedData(bytes: data)
        
    }
    
    func openGalleryApp(completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let url = URL(string: "photos-redirect://") else {
            completion(.failure(PigeonError(code: "INVALID_URL", message: "The URL scheme is invalid.", details: "Unable to create a URL for 'photos-redirect://'.")))
            return
        }
        guard UIApplication.shared.canOpenURL(url) else {
            completion(.failure(PigeonError(code: "CANNOT_OPEN_URL", message: "Cannot open the Photos app.", details: "The device may not have the Photos app installed or it may not support the URL scheme.")))
            return
        }
        UIApplication.shared.open(url, completionHandler: { success in
            if success {
                completion(.success(()))
            } else {
                completion(.failure(PigeonError(code: "UNKNOWN_ERROR", message: "Failed to open the Photos app.", details: "An unknown error occurred when trying to open the Photos app.")))
            }
        })
        
    }
    
    func saveImageToGallery(imageBytes: FlutterStandardTypedData, name: String, albumName: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard UIImage(data: imageBytes.data) != nil else {
            completion(.failure(PigeonError(code: "INVALID_IMAGE", message: "Unable to create UIImage from image bytes.", details: nil)))
            return
        }
        
        let needsReadWritePermission = ProcessInfo.processInfo.operatingSystemVersion.majorVersion < 14 || albumName != nil
        
        let permissionKey = needsReadWritePermission ? "NSPhotoLibraryUsageDescription" : "NSPhotoLibraryAddUsageDescription"
        guard let infoPlist = Bundle.main.infoDictionary,
              let permissionDescription = infoPlist[permissionKey] as? String else {
            completion(.failure(PigeonError(
                code: "IOS_INFO_PLIST_NOT_CONFIGURED",
                message: "The iOS `Info.plist` file has not been configured. The key `\(permissionKey)` is not set.",
                details: nil
            )))
            return
        }
        
        func handlePermissionDenied(status: PHAuthorizationStatus) {
            completion(.failure(PigeonError(
                code: "PERMISSION_DENIED",
                message: "The app doesn't have permission to save photos to the gallery.",
                details: String(describing: status)
            )))
        }
        
        func isAccessBlocked(status: PHAuthorizationStatus) -> Bool {
            return status == .denied || status == .restricted
        }
        
        if #available(iOS 14, *) {
            let accessLevel: PHAccessLevel = needsReadWritePermission ? .readWrite : .addOnly
            
            let currentStatus = PHPhotoLibrary.authorizationStatus(for: accessLevel)
            
            guard !isAccessBlocked(status: currentStatus) else {
                handlePermissionDenied(status: currentStatus)
                return
            }
            
            if currentStatus == .notDetermined {
                PHPhotoLibrary.requestAuthorization(for: accessLevel) { status in
                    guard !isAccessBlocked(status: status) else {
                        handlePermissionDenied(status: status)
                        return
                    }
                }
            }
        } else {
            // For iOS 13 and previous versions
            let currentStatus = PHPhotoLibrary.authorizationStatus()
            
            guard !isAccessBlocked(status: currentStatus) else {
                handlePermissionDenied(status: currentStatus)
                return
            }
            
            if currentStatus == .notDetermined {
                PHPhotoLibrary.requestAuthorization { status in
                    guard !isAccessBlocked(status: status) else {
                        handlePermissionDenied(status: status)
                        return
                    }
                }
            }
        }
        
        // TODO(save-image): Warning "Attempted fetch within change block can trigger deadlock, returning unauthorized fetch result", fix for macOS too.
        
        PHPhotoLibrary.shared().performChanges({
            let assetRequest = PHAssetCreationRequest.forAsset()
            
            let options = PHAssetResourceCreationOptions()
            options.originalFilename = name
            assetRequest.addResource(with: .photo, data: imageBytes.data, options: options)
            
            if let albumName = albumName {
                
                let albumFetchOptions = PHFetchOptions()
                albumFetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
                let existingAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: albumFetchOptions).firstObject
                
                if existingAlbum == nil {
                    // Create the album
                    let albumChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                    albumChangeRequest.addAssets([assetRequest.placeholderForCreatedAsset] as NSArray)
                    
                } else if let album = existingAlbum {
                    // Add the image to the existing album
                    let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                    albumChangeRequest?.addAssets([assetRequest.placeholderForCreatedAsset] as NSArray)
                }
            }
        }) { success, error in
            guard success else {
                completion(.failure(PigeonError(
                    code: "SAVE_FAILED",
                    message: "Failed to save the image to the gallery: \(error?.localizedDescription)",
                    details: String(describing: error)
                )))
                return
            }
            completion(.success(()))
        }
    }
}
