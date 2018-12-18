//
//  ARSurfaceDetectionConfiguration.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit

final class ARSurfaceDetectionConfiguration: ARWorldTrackingConfiguration {
    
    /// - SeeAlso: ARWorldTrackingConfiguration.init()
    override init() {
        super.init()
        setupProperties()
    }
    
    /// Method to setup configuration properties
    private func setupProperties() {
        isAutoFocusEnabled = true
        planeDetection = [.horizontal, .vertical]
    }
}
