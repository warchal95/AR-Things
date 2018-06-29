//
//  UIAlertControllerExtension.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func simple(title: String, actionTitle: String = "Ok") -> UIAlertController {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        return alertController
    }
}

