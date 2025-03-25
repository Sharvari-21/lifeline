package com.example.sharvari

import android.content.pm.PackageManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.Manifest
import android.telephony.SmsManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.IntentFilter
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CALL_CHANNEL = "emergency/call"
    private val SMS_CHANNEL = "emergency/sos"
    private val CALL_PERMISSION_REQUEST = 101
    private val SMS_PERMISSION_REQUEST = 102
    private var pendingPhoneNumber: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CALL_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "callNumber" -> {
                    val number = call.argument<String>("number") ?: ""
                    handleCallPermission(number, result)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendSOSMessage" -> {
                    val contacts = call.argument<List<String>>("contacts")
                    val message = call.argument<String>("message")
                    if (contacts != null && message != null) {
                        sendSOSMessage(contacts, message)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Contacts or message is missing", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun handleCallPermission(number: String, result: MethodChannel.Result) {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED) {
            makeDirectCall(number)
            result.success(true)
        } else {
            pendingPhoneNumber = number
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CALL_PHONE), CALL_PERMISSION_REQUEST)
            result.success("Requesting call permission...")
        }
    }

    private fun makeDirectCall(number: String) {
        val intent = Intent(Intent.ACTION_CALL).apply {
            data = Uri.parse("tel:$number")
        }
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED) {
            startActivity(intent)
        }
    }

    private fun sendSOSMessage(contacts: List<String>, message: String) {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED) {
            val smsManager = SmsManager.getDefault()
            val parts = smsManager.divideMessage(message)

            contacts.forEach { contact ->
                val sentIntents = ArrayList<PendingIntent>().apply {
                    repeat(parts.size) { add(PendingIntent.getBroadcast(this@MainActivity, 0, Intent("SMS_SENT"), PendingIntent.FLAG_IMMUTABLE)) }
                }
                val deliveredIntents = ArrayList<PendingIntent>().apply {
                    repeat(parts.size) { add(PendingIntent.getBroadcast(this@MainActivity, 0, Intent("SMS_DELIVERED"), PendingIntent.FLAG_IMMUTABLE)) }
                }

                smsManager.sendMultipartTextMessage(contact, null, parts, sentIntents, deliveredIntents)
            }
        } else {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.SEND_SMS), SMS_PERMISSION_REQUEST)
        }
    }
}
