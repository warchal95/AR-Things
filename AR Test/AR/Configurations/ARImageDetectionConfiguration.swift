//
//  ARMainConfiguration.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit

final class ARImageDetectionConfiguration: ARWorldTrackingConfiguration {

    override init() {
        super.init()

        setupProperties()
    }

    /// Method to setup configuration properties
    private func setupProperties() {
        isAutoFocusEnabled = true
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil),
            let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "Objects", bundle: nil)
            else {
                fatalError("Couldn't load AR Reference Images")
        }
        detectionImages = referenceImages
        detectionObjects = referenceObjects
    }
}
