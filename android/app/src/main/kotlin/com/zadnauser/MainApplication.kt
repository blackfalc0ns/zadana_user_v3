package com.zadnauser

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

        notificationManager.createNotificationChannel(headsUpChannel)
    }

    companion object {
        const val HEADS_UP_CHANNEL_ID = "zadana_heads_up_notifications"
    }
}
