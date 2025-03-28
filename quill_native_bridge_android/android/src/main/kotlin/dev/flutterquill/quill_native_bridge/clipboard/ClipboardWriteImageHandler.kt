package dev.flutterquill.quill_native_bridge.clipboard

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.graphics.Bitmap
import androidx.core.content.FileProvider
import dev.flutterquill.quill_native_bridge.generated.FlutterError
import dev.flutterquill.quill_native_bridge.util.ImageDecoderCompat
import java.io.File
import java.io.IOException

object ClipboardWriteImageHandler {
    fun copyImageToClipboard(
        context: Context,
        imageBytes: ByteArray,
    ) {
        val bitmap: Bitmap =
            try {
                ImageDecoderCompat.decodeBitmapFromBytes(imageBytes)
            } catch (e: IOException) {
                throw FlutterError(
                    "INVALID_IMAGE",
                    "The provided image bytes are invalid, image could not be decoded: ${e.message}",
                    e.toString(),
                )
            }

        val tempImageFile = File(context.cacheDir, "temp_clipboard_image.png")

        try {
            tempImageFile.outputStream().use { outputStream ->
                val compressedSuccessfully =
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
                if (!compressedSuccessfully) {
                    throw FlutterError(
                        "COULD_NOT_COMPRESS_IMAGE",
                        "Unknown error while compressing the image",
                        null,
                    )
                }
            }
        } catch (e: Exception) {
            throw FlutterError(
                "COULD_NOT_SAVE_TEMP_FILE",
                "Unknown error while compressing and saving the temporary image file: ${e.message}",
                e.toString(),
            )
        }

        if (!tempImageFile.exists()) {
            throw FlutterError(
                "TEMP_FILE_NOT_FOUND",
                "Recently created temporary file for copying the image to the clipboard is missing.",
                null,
            )
        }

        val authority = "${context.packageName}.fileprovider"

        val imageUri =
            try {
                FileProvider.getUriForFile(
                    context,
                    authority,
                    tempImageFile,
                )
            } catch (e: IllegalArgumentException) {
                throw FlutterError(
                    "ANDROID_MANIFEST_NOT_CONFIGURED",
                    "You need to configure your AndroidManifest.xml file " +
                        "to register the provider with the meta-data with authority " +
                        authority,
                    e.toString(),
                )
            }

        try {
            val clipboard =
                context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            val clip = ClipData.newUri(context.contentResolver, "Image", imageUri)
            clipboard.setPrimaryClip(clip)

            // Don't delete the temporary image file, other apps will be unable to retrieve the image
            // tempImageFile.delete()
        } catch (e: Exception) {
            throw FlutterError(
                "COULD_NOT_COPY_IMAGE_TO_CLIPBOARD",
                "Unknown error while copying the image to the clipboard: ${e.message}",
                e.toString(),
            )
        }
    }
}
