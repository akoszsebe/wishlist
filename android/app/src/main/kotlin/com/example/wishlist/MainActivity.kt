package com.example.wishlist

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel;

import android.os.Bundle;
import android.os.BatteryManager
import android.content.Intent
import android.content.IntentFilter
import android.content.ContextWrapper
import android.content.Context.BATTERY_SERVICE
import android.os.Build.VERSION_CODES
import android.os.Build.VERSION
import android.app.AlarmManager
import android.content.Context
import android.app.PendingIntent
import android.os.SystemClock



class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"
    private var alarmMgr: AlarmManager? = null
    private lateinit var alarmIntent: PendingIntent

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        { call, result ->
                            if (call.method.equals("setAlarm")) {
                                var time : Int? = call.argument("time");
                                println("itt  getbatery "+ time)
                                setAlarm(time!!);
                                result.success(true);
                            } else {
                                result.notImplemented()
                            }
                        }
                )
    }

    private fun setAlarm(time : Int){
        alarmMgr = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        var intent = Intent(context, SampleBootReceiver::class.java)
        alarmIntent =  PendingIntent.getBroadcast(context, 0, intent, 0)

        println("system itt  set mak "+ SystemClock.elapsedRealtime())
        var ido = SystemClock.elapsedRealtime() + time;
        println("itt  set mak "+ ido)
        alarmMgr?.set(
                AlarmManager.ELAPSED_REALTIME_WAKEUP,
                ido,
                alarmIntent
        )
        println("itt  set utan mak ")
    }

    private fun getBatteryLevel(): Int {
        var batteryLevel = -1
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(getApplicationContext()).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent!!.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }
}
