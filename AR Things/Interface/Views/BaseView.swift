//
//  BaseView.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import UIKit.UIView

public class BaseView: UIView {
    
    /// - SeeAlso: UIView.init()
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
    }

    @available(*, unavailable, message: "Use init(frame:) instead")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Abstract
    /// Sets up layout and subviews in `self`.
    func setupLayout() { }
}

