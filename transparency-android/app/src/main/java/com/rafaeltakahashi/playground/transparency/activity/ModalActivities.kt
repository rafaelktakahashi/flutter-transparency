package com.rafaeltakahashi.playground.transparency.activity

import android.content.Context
import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

class CustomFlutterActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? = FlutterEngineCache.getInstance().get("engine")

    override fun getBackgroundMode(): FlutterActivityLaunchConfigs.BackgroundMode =
         FlutterActivityLaunchConfigs.BackgroundMode.transparent

}