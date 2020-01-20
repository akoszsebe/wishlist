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
import android.os.Build
import android.app.AlarmManager
import android.content.Context
import android.app.PendingIntent
import android.os.SystemClock
import android.view.WindowManager



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
                                var time : Long? = call.argument("time");
                                var id : Int? = call.argument("id");
                                var title : String? = call.argument("title");
                                setAlarm(time!!, id!!, title!!);
                                result.success(true);
                            } else if (call.method.equals("getIntentParams")) {
                                val resultt:String = intent.getStringExtra("needAlarm") ?: "default";
                                val title:String = intent.getStringExtra("title") ?: "";
                                intent.removeExtra("needAlarm");
                                println(resultt + title);
                                result.success(resultt + ":" + title);
                            } else if (call.method.equals("finishAndRemoveTask")) { 
                                finishAndRemoveTask();
                            } else {
                                result.notImplemented()
                            }
                        }
                )
        val result :String = intent.getStringExtra("needAlarm") ?: "default";
        if (result.startsWith("alarm")){
            unlockScreen()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
                setTurnScreenOn(true)
                setShowWhenLocked(true)
            }
        }
    }

    private fun unlockScreen() {
        val window = this.window
        window.addFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD)
        window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED)
        window.addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
    }

    private fun setAlarm(time : Long, id : Int, title : String){
        alarmMgr = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        var intent = Intent(context, SampleBootReceiver::class.java)
        intent.putExtra("title", title);
        alarmIntent =  PendingIntent.getBroadcast(context, 0, intent, 0)
        println("set alarm for  "+ time)
        alarmMgr?.set(
                AlarmManager.RTC_WAKEUP,
                time,
                alarmIntent
        )
    }
}
