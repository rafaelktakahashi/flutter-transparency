//
//  ViewController.swift
//  Transparency
//
//  Created by Rafael Takahashi on 26/05/23.
//

import UIKit
import Flutter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openModal(_ sender: UIButton) {
        showFlutter(pageName: "modal")
    }
    
    @IBAction func openCard(_ sender: UIButton) {
        showFlutter(pageName: "card")
    }
    
    @objc func showFlutter(pageName: String) {
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        // Prefer using an interop navigator. Don't copy this method channel code.
        let channel = FlutterMethodChannel(name: "method-channel", binaryMessenger: flutterViewController.binaryMessenger)
        channel.invokeMethod("navigate", arguments: pageName)
        
        /// My observations about which styles work for showing Flutter modals:
        ///
        /// .fullScreen - Doesn't work, main view is unloaded.
        /// .pageSheet - Works, shrinks the native view a bit and shows the Flutter view over it. The user can slide the Flutter view downward to dismiss it. Note that in iPads, the native view behind it doesn't shrink and some space is left on either side of the Flutter view.
        /// .formSheet - Works, same as .pageSheet but renders in a smaller window in large screens.
        /// .currentContext - Doesn't work; slides the Flutter view upward and the view behind it is unloaded.
        /// .custom - Works; without further configs, it's the same as .overFullScreen.
        /// .overFullScreen - Works, slides the Flutter view above without changing the native view. The user cannot slide the Flutter view as with .pageSheet, thus popping the view needs to be done manually since the back gesture doesn't work either (since the page slides upwards).
        /// .overCurrentContext - Works, similar to .overFullScreen but renders inside the current view if it's a modal, rather than using the whole screen. There's no difference to .overFullScreen in this example.
        /// .popover - Same as .formSheet in iOS 13, and same as .fullScreen in iOS 12.
        /// .blurOverFullScreen - Do not use. Available only in tvOS 11+.
        /// .none - Do not use, causes a crash. This is not meant to be used for showing views.
        /// .automatic (iOS 13+ only) - May vary depending on the native controller; here, it does the same as .pageSheet.
        flutterViewController.modalPresentationStyle = .overFullScreen
        /// Tells Flutter to allow transparency.
        flutterViewController.isViewOpaque = false
        
        present(flutterViewController, animated: true, completion: nil)
    }

}

