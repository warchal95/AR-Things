//
//  BaseView.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import UIKit

public class BaseView: UIView {
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupLayout()
    }

    @available(*, unavailable, message: "Use init(frame:) instead")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Abstract
    /// Sets up layout and subviews in `self`.
    internal func setupLayout() { }
}

