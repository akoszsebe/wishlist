package com.example.wishlist

import android.content.BroadcastReceiver
import android.content.Context
import android.widget.Toast
import android.content.Intent

class SampleBootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        println("received itt mak ")
        var title :String = intent.getStringExtra("title") ?: "";
        val i = Intent()
        i.setClassName("com.example.wishlist", "com.example.wishlist.MainActivity")
        i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)
        i.putExtra("needAlarm","alarm")
        i.putExtra("title", title)
        context.startActivity(i)
    }
}