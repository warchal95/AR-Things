//
//  ARObjectDetectionConfiguration.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit

final class ARObjectDetectionConfiguration: ARWorldTrackingConfiguration {

    override init() {
        super.init()

        setupProperties()
    }

    /// Method to setup configuration properties
    private func setupProperties() {
        isAutoFocusEnabled = true
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil),
            let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "AR Objects", bundle: nil)
        else {
            fatalError("Couldn't load AR resources")
        }
        detectionImages = referenceImages
        detectionObjects = referenceObjects
    }
}
