package com.example.zadana_user_v3

import androidx.annotation.Keep
import androidx.core.app.NotificationCompat
import com.onesignal.notifications.IDisplayableMutableNotification
import com.onesignal.notifications.INotificationReceivedEvent
import com.onesignal.notifications.INotificationServiceExtension
import org.json.JSONObject

@Keep
class OneSignalNotificationServiceExtension : INotificationServiceExtension {
    override fun onNotificationReceived(event: INotificationReceivedEvent) {
        val notification = event.notification
        if (shouldPassThrough(notification)) {
            return
        }
        forceNotificationChannel(notification)
    }

    private fun shouldPassThrough(notification: IDisplayableMutableNotification): Boolean {
        val additionalDataType = notification.additionalData
            ?.optString("type")
            ?.trim()
            ?.lowercase()
        if (additionalDataType in passThroughTypes) {
            return true
        }

        val rawPayloadType = runCatching {
            JSONObject(notification.rawPayload)
                .optJSONObject("custom")
                ?.optJSONObject("a")
                ?.optString("type")
                ?.trim()
                ?.lowercase()
        }.getOrNull()

        return rawPayloadType in passThroughTypes
    }

    private fun forceNotificationChannel(notification: IDisplayableMutableNotification) {
        val channelId = resolveChannelId(notification)
        notification.setExtender { builder: NotificationCompat.Builder ->
            builder
                .setChannelId(channelId)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setDefaults(NotificationCompat.DEFAULT_ALL)
                .setColor(NOTIFICATION_ACCENT_COLOR)
                .setSmallIcon(R.drawable.ic_stat_onesignal_default)
        }
    }

    private fun resolveChannelId(notification: IDisplayableMutableNotification): String {
        val additionalData = notification.additionalData
        val payloadChannelId = additionalData?.optString("android_channel_id")?.trim()
        if (!payloadChannelId.isNullOrEmpty()) {
            return payloadChannelId
        }

        val existingPayloadChannelId =
            additionalData?.optString("existing_android_channel_id")?.trim()
        if (!existingPayloadChannelId.isNullOrEmpty()) {
            return existingPayloadChannelId
        }

        val rawPayloadChannelId = runCatching {
            JSONObject(notification.rawPayload).optString("android_channel_id").trim()
        }.getOrNull()
        if (!rawPayloadChannelId.isNullOrEmpty()) {
            return rawPayloadChannelId
        }

        val existingRawPayloadChannelId = runCatching {
            JSONObject(notification.rawPayload).optString("existing_android_channel_id").trim()
        }.getOrNull()
        if (!existingRawPayloadChannelId.isNullOrEmpty()) {
            return existingRawPayloadChannelId
        }

        return MainApplication.HEADS_UP_CHANNEL_ID
    }

    companion object {
        // #007A92 - app primary color
        private const val NOTIFICATION_ACCENT_COLOR = 0xFF007A92.toInt()

        private val passThroughTypes = setOf(
            "order_status_changed",
            "order_cancelled",
            "order_placed",
        )
    }
}
