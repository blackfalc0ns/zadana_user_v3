package com.example.zadana_user_v3

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.os.Build

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        createNotificationChannels()
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val notificationManager =
            getSystemService(NotificationManager::class.java) ?: return

        val headsUpChannel = NotificationChannel(
            HEADS_UP_CHANNEL_ID,
            getString(R.string.onesignal_heads_up_channel_name),
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = getString(R.string.onesignal_heads_up_channel_description)
            enableVibration(true)
            setShowBadge(true)
            lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
            val soundUri = android.provider.Settings.System.DEFAULT_NOTIFICATION_URI
            val audioAttributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .build()
            setSound(soundUri, audioAttributes)
        }

        val orderUpdatesChannel = NotificationChannel(
            ORDER_UPDATES_CHANNEL_ID,
            "Zadana Order Updates",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = "Heads-up alerts for live order status updates"
            enableVibration(true)
            setShowBadge(true)
            lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
            val soundUri = android.provider.Settings.System.DEFAULT_NOTIFICATION_URI
            val audioAttributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .build()
            setSound(soundUri, audioAttributes)
        }

        notificationManager.createNotificationChannel(headsUpChannel)
        notificationManager.createNotificationChannel(orderUpdatesChannel)
    }

    companion object {
        const val HEADS_UP_CHANNEL_ID = "zadana_heads_up_notifications"
        const val ORDER_UPDATES_CHANNEL_ID = "zadana_order_updates_realtime_v2"
    }
}
