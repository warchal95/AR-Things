//
//  TabBarController.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let surfaceDetectionViewController = ARSurfaceDetectionViewController()
        surfaceDetectionViewController.tabBarItem = UITabBarItem(title: "Surface Detection", image: #imageLiteral(resourceName: "Surface_icon"), selectedImage: nil)

        let imageDetectionViewController = ARImageDetectionViewController()
        imageDetectionViewController.tabBarItem = UITabBarItem(title: "Image Detection", image: #imageLiteral(resourceName: "ImageDetection_icon"), selectedImage: nil)

        let objectPlacementViewController = ARObjectPlacementViewController()
        objectPlacementViewController.tabBarItem = UITabBarItem(title: "3D Objects", image: #imageLiteral(resourceName: "3D_icon"), selectedImage: nil)

        viewControllers = [
            surfaceDetectionViewController,
            imageDetectionViewController,
            objectPlacementViewController
        ]
    }
}