//
//  ViewController.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit
import SceneKit

final class ARImageDetectionViewController: ARViewController {
    
    private struct Constants {
        static let car = "Alfa Romeo Giulia"
        static let monaLisa = "Mona Lisa - Leonardo da Vinci"
        static let theScream = "The Scream - Munch"
        static let landscape = "Landscape"
    }

    override func runSession() {
        sceneContainer.sceneView.session.run(ARImageDetectionConfiguration())
    }

    override func setupProperties() {
        sceneContainer.sceneView.delegate = self
    }
}

// MARK: ARSCNViewDelegate
extension ARImageDetectionViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }

        let referenceImage = imageAnchor.referenceImage
        let textNode = generateTextNode(for: referenceImage)

        textNode.eulerAngles.x = -.pi / 2
        node.addChildNode(textNode)
    }
}

extension ARImageDetectionViewController {
    private func detectNameFor(_ referenceImage: ARReferenceImage) -> String {
        switch referenceImage.name {
        case Constants.car: return "Car"
        case Constants.monaLisa: return "Mona Lisa"
        case Constants.theScream: return "The Scream"
        case Constants.landscape: return "Landscape"
        default: return ""
        }
    }
    
    private func generateTextNode(for referenceImage: ARReferenceImage) -> SCNNode {
        let text = detectNameFor(referenceImage)

        let geoText = SCNText(string: text, extrusionDepth: 0.04)
        geoText.font = UIFont(name: "Arial", size: 0.12)        
        geoText.firstMaterial!.diffuse.contents = #colorLiteral(red: 0.01176470588, green: 0.8117647059, blue: 0.3450980392, alpha: 1)
        let textNode = SCNNode(geometry: geoText)

        let (minVec, maxVec) = textNode.boundingBox
        textNode.pivot = SCNMatrix4MakeTranslation((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0)

        return textNode
    }
}
