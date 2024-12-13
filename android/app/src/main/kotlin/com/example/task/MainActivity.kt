package com.example.task

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "dns_configurator"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateDNS") {
                val dns = call.argument<String>("dns")
                if (dns != null) {
                    // Example: Replace this logic with actual Android DNS update code
                    result.success("DNS updated to $dns")
                } else {
                    result.error("INVALID_IP", "Invalid DNS address", null)
                }
            }
        }
    }
}
