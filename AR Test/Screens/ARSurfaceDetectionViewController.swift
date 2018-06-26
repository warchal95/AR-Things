//
//  ARSurfaceDetectionViewController.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit
import SceneKit

final class ARSurfaceDetectionViewController: ARViewController {
    
    override func runSession() {
        sceneContainer.sceneView.session.run(ARSurfaceDetectionConfiguration())
    }
    
    override func setupProperties() {
        sceneContainer.sceneView.delegate = self
    }
}

// MARK: Node handlers
extension ARSurfaceDetectionViewController {
    private func createNodeForAnchor(_ anchor: ARPlaneAnchor, type: SurfaceType) -> SCNNode {
        let node = SCNNode()
        
        node.name = type.name
        node.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        node.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        node.geometry?.firstMaterial?.diffuse.contents = type == .horizontal ? #imageLiteral(resourceName: "Floor") : #imageLiteral(resourceName: "Wall")
        node.geometry?.firstMaterial?.isDoubleSided = true
        node.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
        
        return node
    }
    
    private func removeNode(type: SurfaceType) {
        sceneContainer.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            guard node.name == type.name else { return }
            node.removeFromParentNode()
        }
    }
}

// MARK: ARSCNViewDelegate
extension ARSurfaceDetectionViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchorPlane = anchor as? ARPlaneAnchor else { return }

        let type: SurfaceType = anchorPlane.alignment == ARPlaneAnchor.Alignment.horizontal ? .horizontal : .vertical
        let newNode = createNodeForAnchor(anchorPlane, type: type)
        
        node.addChildNode(newNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let anchorPlane = anchor as? ARPlaneAnchor else { return }

        let type: SurfaceType = anchorPlane.alignment == ARPlaneAnchor.Alignment.horizontal ? .horizontal : .vertical
        let newNode = createNodeForAnchor(anchorPlane, type: type)
        
        /// Remove old node for that name
        removeNode(type: type)
        
        /// Create new one with updated shape
        node.addChildNode(newNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let anchorPlane = anchor as? ARPlaneAnchor else { return }

        let type: SurfaceType = anchorPlane.alignment == ARPlaneAnchor.Alignment.horizontal ? .horizontal : .vertical
        removeNode(type: type)
    }
}


private enum SurfaceType {
    case horizontal
    case vertical
    
    var name: String {
        switch self {
        case .horizontal: return "Floor"
        case .vertical: return "Wall"
        }
    }
}
