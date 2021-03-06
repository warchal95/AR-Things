//
//  AppDelegate.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import UIKit.UIWindow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// Main window of the application
    var window: UIWindow?

    /// - SeeAlso: UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = TabBarController()
        window!.makeKeyAndVisible()
        return true
    }
}
