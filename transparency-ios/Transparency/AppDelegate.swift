//
//  AppDelegate.swift
//  Transparency
//
//  Created by Rafael Takahashi on 26/05/23.
//

import UIKit
import Flutter
import FlutterPluginRegistrant

// Icon from FlatIcons: https://www.flaticon.com/free-icons/halloween-party


@main
class AppDelegate: FlutterAppDelegate {
    lazy var flutterEngine = FlutterEngine(name: "engine")

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        flutterEngine.run();
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions);
    }


}

