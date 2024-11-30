package dev.flutterquill.quill_native_bridge.util

import android.content.ContentResolver
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.ImageDecoder
import android.net.Uri
import android.os.Build
import java.io.IOException

/**
 * Similar to [ImageDecoder] but compatible with older Android versions by fallback to use
 * older APIs.
 * */
object ImageDecoderCompat {
    /**
     * Uses [ImageDecoder.decodeBitmap] on Android API 31 and newer, fallback to [BitmapFactory.decodeByteArray]
     * on older versions.
     *
     * @throws IOException if unsupported, or or cannot be decoded for any reason.
     * @see decodeBitmapFromUri
     * */
    @Throws(IOException::class)
    fun decodeBitmapFromBytes(imageBytes: ByteArray): Bitmap {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // API 31 and above (use a newer API)
            val source = ImageDecoder.createSource(imageBytes)
            ImageDecoder.decodeBitmap(source)
        } else {
            // Backward compatibility with older versions
            BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
                ?: throw IOException("Image could not be decoded using the `BitmapFactory.decodeByteArray`.")
        }
    }

    /**
     * Uses [ImageDecoder.decodeBitmap] on Android API 28 and newer, fallback to [BitmapFactory.decodeStream]
     * on older versions.
     *
     * @throws IOException if unsupported, or or cannot be decoded for any reason.
     * @see decodeBitmapFromBytes
     * */
    @Throws(IOException::class)
    fun decodeBitmapFromUri(contentResolver: ContentResolver, imageUri: Uri): Bitmap {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            // API 28 and above (use a newer API)
            val source = ImageDecoder.createSource(contentResolver, imageUri)
            ImageDecoder.decodeBitmap(source)
        } else {
            // Backward compatibility with older versions
            checkNotNull(contentResolver.openInputStream(imageUri)) {
                "Input stream is null, the provider might have recently crashed."
            }.use { inputStream ->
                val bitmap: Bitmap = BitmapFactory.decodeStream(inputStream)
                    ?: throw IOException("The image could not be decoded using the `BitmapFactory.decodeStream`.")
                bitmap
            }
        }
    }

    fun isValidImage(imageBytes: ByteArray) = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size) != null
}