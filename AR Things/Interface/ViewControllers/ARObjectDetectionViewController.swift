//
//  ARObjectDetectionViewController.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit
import SceneKit

final class ARObjectDetectionViewController: ARViewController {
    
    private struct Constants {
        static let car = "Alfa Romeo Giulia"
        static let monaLisa = "Mona Lisa - Leonardo da Vinci"
        static let theScream = "The Scream - Munch"
        static let landscape = "Landscape"
        static let sceneName = "ObjectInfo"
    }

    /// - SeeAlso: ARViewController.runSession()
    override func runSession() {
        sceneContainer.sceneView.session.run(ARObjectDetectionConfiguration())
    }

    /// - SeeAlso: ARViewController.setupProperties()
    override func setupProperties() {
        sceneContainer.sceneView.delegate = self
    }
}

// MARK: ARSCNViewDelegate
extension ARObjectDetectionViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let objectAnchor = anchor as? ARObjectAnchor {
            let sceneGeometry = generateSceneGeometry(forAnchor: objectAnchor)
            let planeNode = SCNNode(geometry: sceneGeometry)

            planeNode.position = SCNVector3Make(
                objectAnchor.referenceObject.center.x,
                objectAnchor.referenceObject.center.y + 0.5,
                objectAnchor.referenceObject.center.z
            )
            node.addChildNode(planeNode)
        } else if let imageAnchor = anchor as? ARImageAnchor {
            let referenceImage = imageAnchor.referenceImage
            let textNode = generateTextNode(forAnchor: referenceImage)
            textNode.eulerAngles.x = -.pi / 2
            node.addChildNode(textNode)
        }
    }
}

extension ARObjectDetectionViewController {
    
    private func detectName(forReferenceImage referenceImage: ARReferenceImage) -> String {
        switch referenceImage.name {
        case Constants.car:
            return "Car"
        case Constants.monaLisa:
            return "Mona Lisa"
        case Constants.theScream:
            return "The Scream"
        case Constants.landscape:
            return "Landscape"
        default:
            return ""
        }
    }
    
    private func generateTextNode(forAnchor referenceImage: ARReferenceImage) -> SCNNode {
        let text = detectName(forReferenceImage: referenceImage)

        let geoText = SCNText(string: text, extrusionDepth: 0.04)
        geoText.font = UIFont(name: "Arial", size: 0.12)        
        geoText.firstMaterial!.diffuse.contents = #colorLiteral(red: 0.01176470588, green: 0.8117647059, blue: 0.3450980392, alpha: 1)
        let textNode = SCNNode(geometry: geoText)

        let (minVec, maxVec) = textNode.boundingBox
        textNode.pivot = SCNMatrix4MakeTranslation((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0)

        return textNode
    }
    
    private func generateSceneGeometry(forAnchor anchor: ARObjectAnchor) -> SCNPlane {
        let width = CGFloat(anchor.referenceObject.extent.x * 0.8)
        let height = CGFloat(anchor.referenceObject.extent.y * 0.25)

        let plane = SCNPlane(width: width, height: height)
        let spriteKitScene = SKScene(fileNamed: Constants.sceneName)

        plane.cornerRadius = plane.width / 8.0
        plane.firstMaterial?.diffuse.contents = spriteKitScene
        plane.firstMaterial?.isDoubleSided = true
        plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        return plane
    }
}
