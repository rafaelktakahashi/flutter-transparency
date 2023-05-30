package com.rafaeltakahashi.playground.transparency

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class TransparencyApp : Application() {
    lateinit var flutterEngine: FlutterEngine

    override fun onCreate() {
        super.onCreate()

        // Pre-warm a Flutter engine. This adds initialization processing,
        // but ensures that the engine will be ready when we need to
        // show a Flutter activity.
        flutterEngine = FlutterEngine(this)

        // Run the Flutter code to ensure it's ready
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        // Cache the engine to use it again later
        FlutterEngineCache
            .getInstance()
            .put("engine", flutterEngine)
    }
}