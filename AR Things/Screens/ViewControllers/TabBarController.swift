//
//  TabBarController.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import UIKit.UITabBarController

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let surfaceDetectionViewController = ARSurfaceDetectionViewController()
        surfaceDetectionViewController.tabBarItem = UITabBarItem(title: "Surface Detection", image: #imageLiteral(resourceName: "Surface_icon"), selectedImage: nil)

        let objectDetectionViewController = ARObjectDetectionViewController()
        objectDetectionViewController.tabBarItem = UITabBarItem(title: "Object Detection", image: #imageLiteral(resourceName: "ImageDetection_icon"), selectedImage: nil)

        let objectPlacementViewController = ARObjectPlacementViewController()
        objectPlacementViewController.tabBarItem = UITabBarItem(title: "3D Objects", image: #imageLiteral(resourceName: "3D_icon"), selectedImage: nil)

        viewControllers = [
            surfaceDetectionViewController,
            objectDetectionViewController,
            objectPlacementViewController
        ]
    }
}
