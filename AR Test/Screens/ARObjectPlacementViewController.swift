//
//  ARObjectPlacementViewController.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import SceneKit
import ARKit

final class ARObjectPlacementViewController: ARViewController {
    
    private struct Constants {
        static let numberOfGeometries = 9
    }
    
    // MARK: - Variables
    private var geometryNumber: Int = 0
    
    // MARK: - Lifecicle methods
    override func runSession() {
        sceneContainer.sceneView.session.run(ARSurfaceDetectionConfiguration())
    }
    
    /// Detect touch and create 3D object if hitTest has result
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let result = sceneContainer.sceneView.hitTest(touch.location(in: sceneContainer.sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitResult = result.last else { return }
    
        /// Column 3 is holding information about position
        let x = hitResult.worldTransform.columns.3.x
        let y = hitResult.worldTransform.columns.3.y
        let z = hitResult.worldTransform.columns.3.z
        
        let hitVector = SCNVector3Make(x, y, z)
        create3DObjectInPosition(hitVector)
    }
    
    /// Creates 3D object and place it in AR world
    private func create3DObjectInPosition(_ position: SCNVector3) {
        let geometry = generateGeometry()

        if let text = geometry as? SCNText {
            addRotatingText(text, in: position)
        } else {
            addRotatingGeometry(geometry, in: position)
        }
    }
}

/// Geometry placement
extension ARObjectPlacementViewController {
    private func addRotatingText(_ text: SCNText, in position: SCNVector3) {
        let textNode = SCNNode(geometry: text)
        textNode.position = position
        
        let (minVec, maxVec) = textNode.boundingBox
        textNode.pivot = SCNMatrix4MakeTranslation((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0)

        sceneContainer.sceneView.scene.rootNode.addChildNode(textNode)

        let loop = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 5, z: 0, duration: 2.5))
        textNode.runAction(loop)
    }
    
    private func addRotatingGeometry(_ geometry: SCNGeometry, in position: SCNVector3) {
        let node = SCNNode(geometry: geometry)
        node.position = position
        
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = #imageLiteral(resourceName: "Netguru_Green")
        
        node.geometry?.firstMaterial = material
        
        sceneContainer.sceneView.scene.rootNode.addChildNode(node)
        
        if geometry is SCNPlane {
            return
        }
    
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)
        let repeatedAction = SCNAction.repeatForever(action)
        node.runAction(repeatedAction, forKey: "ARTest.ARObjectPlacementViewController.rotation")
    }
}

/// Geometry generators
extension ARObjectPlacementViewController {
    /// Geometry generator
    private func generateGeometry() -> SCNGeometry {
        geometryNumber += 1
        
        if geometryNumber > Constants.numberOfGeometries {
            geometryNumber = 1
        }
        
        switch geometryNumber {
        case 1: return SCNSphere(radius: 0.05)
        case 2: return SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.04)
        case 3: return SCNTube(innerRadius: 0.06, outerRadius: 0.08, height: 0.12)
        case 4: return SCNPyramid(width: 0.08, height: 0.12, length: 0.08)
        case 5: return SCNCylinder(radius: 0.08, height: 0.04)
        case 6: return SCNCapsule(capRadius: 0.05, height: 0.08)
        case 7: return SCNTorus(ringRadius: 0.07, pipeRadius: 0.08)
        case 8: return SCNPlane(width: 0.5, height: 0.5)
        case 9: return generateSCNText()
        default: return SCNSphere(radius: 0.05)
        }
    }
    
    /// SCNText generator
    private func generateSCNText() -> SCNText {
        let text = SCNText(string: "Netguru", extrusionDepth: 0.05)
        text.font = UIFont (name: "Arial", size: 0.15)
        text.firstMaterial!.diffuse.contents = #colorLiteral(red: 0.01176470588, green: 0.8117647059, blue: 0.3450980392, alpha: 1)
        return text
    }
}
