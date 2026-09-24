package dev.localmessenger.app

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "dev.localmessenger.app/permissions"
    private val notificationRequestCode = 7431
    private var pendingNotificationResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "notificationStatus" -> result.success(notificationsAllowed())
                    "requestNotifications" -> {
                        if (notificationsAllowed()) {
                            result.success(true)
                        } else if (pendingNotificationResult != null) {
                            result.error("in_progress", "Notification request already open", null)
                        } else {
                            pendingNotificationResult = result
                            requestPermissions(
                                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                                notificationRequestCode,
                            )
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun notificationsAllowed(): Boolean =
        Build.VERSION.SDK_INT < 33 ||
            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) ==
                PackageManager.PERMISSION_GRANTED

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == notificationRequestCode) {
            pendingNotificationResult?.success(notificationsAllowed())
            pendingNotificationResult = null
        }
    }
}
