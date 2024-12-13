import FlutterMacOS
import Foundation
import Photos

class QuillNativeBridgeImpl: QuillNativeBridgeApi {
  func getClipboardHtml() throws -> String? {
    guard let htmlData = NSPasteboard.general.data(forType: .html) else {
      return nil
    }
    let html = String(data: htmlData, encoding: .utf8)
    return html
  }

  func copyHtmlToClipboard(html: String) throws {
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(html, forType: .html)
  }

  func getClipboardImage() throws -> FlutterStandardTypedData? {
    // TODO: This can return null when copying an image from some apps (e.g Telegram, Apple notes), seems to work with macOS screenshot and Google Chrome, attemp to fix it later
    guard
      let image = NSPasteboard.general.readObjects(forClasses: [NSImage.self], options: nil)?.first
        as? NSImage
    else {
      return nil
    }
    guard let tiffData = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiffData),
      let pngData = bitmap.representation(using: .png, properties: [:])
    else {
      return nil
    }
    return FlutterStandardTypedData(bytes: pngData)
  }

  func copyImageToClipboard(imageBytes: FlutterStandardTypedData) throws {
    guard let image = NSImage(data: imageBytes.data) else {
      throw PigeonError(
        code: "INVALID_IMAGE", message: "Unable to create NSImage from image bytes.", details: nil)
    }

    guard let tiffData = image.tiffRepresentation else {
      throw PigeonError(
        code: "INVALID_IMAGE", message: "Unable to get TIFF representation from NSImage.",
        details: nil)
    }

    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setData(tiffData, forType: .png)
  }

  func getClipboardGif() throws -> FlutterStandardTypedData? {
    let availableTypes = NSPasteboard.general.types
    throw PigeonError(
      code: "GIF_UNSUPPORTED",
      message:
        "Gif image is not supported on macOS. Available types: \(String(describing: availableTypes))",
      details: nil)
  }

  func getClipboardFiles() throws -> [String] {
    guard
      let urlList = NSPasteboard.general.readObjects(forClasses: [NSURL.self], options: nil)
        as? [NSURL]
    else {
      return []
    }
    return urlList.compactMap { url in url.path }
  }

  func openGalleryApp() throws {
    guard let url = URL(string: "photos://") else {
      throw PigeonError(
        code: "INVALID_URL", message: "The URL scheme is invalid.",
        details: "Unable to create a URL for 'photos://'.")
    }

    let workspace = NSWorkspace.shared
    let canOpen = workspace.urlForApplication(toOpen: url) != nil

    guard canOpen else {
      throw PigeonError(
        code: "CANNOT_OPEN_URL", message: "Cannot open the Photos app.",
        details:
          "The desktop may not have the Photos app installed or it may not support the URL scheme.")
    }

    workspace.open(url)
  }

  func supportsGallerySave() throws -> Bool {
    guard #available(macOS 10.15, *) else {
      return false
    }
    return true
  }

  func saveImageToGallery(
    imageBytes: FlutterStandardTypedData, name: String, albumName: String?,
    completion: @escaping (Result<Void, any Error>) -> Void
  ) {
    guard NSImage(data: imageBytes.data) != nil else {
      completion(
        .failure(
          PigeonError(
            code: "INVALID_IMAGE", message: "Unable to create NSImage from image bytes.",
            details: nil)))
      return
    }

    let macOSVersion = ProcessInfo.processInfo.operatingSystemVersion

    guard #available(macOS 10.15, *) else {
      completion(
        .failure(
          PigeonError(
            code: "UNSUPPORTED",
            message: "Saving images to the system gallery is supported on macOS 10.15 and later.",
            details:
              "The current macOS version is: \(macOSVersion.majorVersion).\(macOSVersion.minorVersion).\(macOSVersion.patchVersion)"
          )))
      return
    }

    let needsReadWritePermission = macOSVersion.majorVersion < 11 || albumName != nil

    let permissionKey =
      needsReadWritePermission
      ? "NSPhotoLibraryUsageDescription" : "NSPhotoLibraryAddUsageDescription"
    guard let infoPlist = Bundle.main.infoDictionary,
      let permissionDescription = infoPlist[permissionKey] as? String
    else {
      completion(
        .failure(
          PigeonError(
            code: "MACOS_INFO_PLIST_NOT_CONFIGURED",
            message:
              "The macOS `Info.plist` file has not been configured. The key `\(permissionKey)` is not set.",
            details: nil
          )))
      return
    }

    func handlePermissionDenied(status: PHAuthorizationStatus) {
      completion(
        .failure(
          PigeonError(
            code: "PERMISSION_DENIED",
            message: "The app doesn't have permission to save photos to the gallery.",
            details: String(describing: status)
          )))
    }

    func isAccessBlocked(status: PHAuthorizationStatus) -> Bool {
      return status == .denied || status == .restricted
    }

    Task {
      if #available(macOS 11, *) {
        let accessLevel: PHAccessLevel = needsReadWritePermission ? .readWrite : .addOnly

        let currentStatus = await PHPhotoLibrary.authorizationStatus(for: accessLevel)

        guard !isAccessBlocked(status: currentStatus) else {
          handlePermissionDenied(status: currentStatus)
          return
        }

        if currentStatus == .notDetermined {
          let status = await PHPhotoLibrary.requestAuthorization(for: accessLevel)

          guard !isAccessBlocked(status: status) else {
            handlePermissionDenied(status: status)
            return
          }
        }
      } else {
        // For macOS 10.15 and previous versions
        let currentStatus = await PHPhotoLibrary.authorizationStatus()

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

      do {
        try await PHPhotoLibrary.shared().performChanges({
          let assetRequest = PHAssetCreationRequest.forAsset()

          let options = PHAssetResourceCreationOptions()
          options.originalFilename = name
          assetRequest.addResource(with: .photo, data: imageBytes.data, options: options)

          if let albumName = albumName {

            let albumFetchOptions = PHFetchOptions()
            albumFetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            let existingAlbum = PHAssetCollection.fetchAssetCollections(
              with: .album, subtype: .any, options: albumFetchOptions
            ).firstObject

            if existingAlbum == nil {
              // Create the album
              let albumChangeRequest =
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(
                  withTitle: albumName)
              albumChangeRequest.addAssets([assetRequest.placeholderForCreatedAsset] as NSArray)

            } else if let album = existingAlbum {
              // Add the image to the existing album
              let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
              albumChangeRequest?.addAssets([assetRequest.placeholderForCreatedAsset] as NSArray)
            }
          }
        })
        completion(.success(()))
      } catch {
        completion(
          .failure(
            PigeonError(
              code: "SAVE_FAILED",
              message: "Failed to save the image to the gallery: \(error.localizedDescription)",
              details: String(describing: error)
            )))
      }
    }
  }

  func saveImage(
    imageBytes: FlutterStandardTypedData, name: String, fileExtension: String,
    completion: @escaping (Result<String?, any Error>) -> Void
  ) {
    guard
      let picturesDirectory = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)
        .first
    else {
      completion(
        .failure(
          PigeonError(
            code: "DIRECTORY_NOT_FOUND",
            message: "Unable to locate the Pictures directory.",
            details: "Could not retrieve the user's Pictures directory."
          )))
      return
    }

    // TODO(save-image) The entitlement com.apple.security.files.user-selected.read-write is required, check if set to avoid crash
    let savePanel = NSSavePanel()
    savePanel.nameFieldStringValue = "\(name).\(fileExtension)"
    savePanel.directoryURL = picturesDirectory

    if #available(macOS 11.0, *) {
      savePanel.allowedContentTypes = [.image]
    } else {
      savePanel.allowedFileTypes = [fileExtension]
    }

    savePanel.begin { result in
      guard result == .OK, let selectedUrl = savePanel.url else {
        completion(.success(nil))
        return
      }

      do {
        try imageBytes.data.write(to: selectedUrl)
        completion(.success(selectedUrl.path))
      } catch {
        completion(
          .failure(
            PigeonError(
              code: "IMAGE_WRITE_FAILED",
              message: "Failed to save the image to the specified location.",
              details:
                "An error occurred while writing the image to \(selectedUrl.path). Error: \(error.localizedDescription)"
            )))
      }
    }

  }
}
