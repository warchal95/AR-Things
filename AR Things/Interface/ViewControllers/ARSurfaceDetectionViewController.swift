//
//  ARSurfaceDetectionViewController.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit
import SceneKit

final class ARSurfaceDetectionViewController: ARViewController {
    
    /// - SeeAlso: ARViewController.runSession()
    override func runSession() {
        sceneContainer.sceneView.session.run(ARSurfaceDetectionConfiguration())
    }
    
    /// - SeeAlso: ARViewController.setupProperties()
    override func setupProperties() {
        sceneContainer.sceneView.delegate = self
    }
}

extension ARSurfaceDetectionViewController {
    
    private func makeNode(forAnchor anchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        node.name = "\(anchor.alignment.rawValue)"
        node.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        node.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        node.geometry?.firstMaterial?.diffuse.contents = anchor.alignment == .horizontal ? #imageLiteral(resourceName: "Floor") : #imageLiteral(resourceName: "Wall")
        node.geometry?.firstMaterial?.isDoubleSided = true
        node.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
        return node
    }
    
    private func removeNode(alignment: ARPlaneAnchor.Alignment) {
        sceneContainer.sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            guard node.name == "\(alignment.rawValue)" else { return }
            node.removeFromParentNode()
        }
    }
}

/// - SeeAlso: ARSCNViewDelegate
extension ARSurfaceDetectionViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let arPlaneAnchor = anchor as? ARPlaneAnchor else { return }

        let newNode = makeNode(forAnchor: arPlaneAnchor)
        node.addChildNode(newNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let arPlaneAnchor = anchor as? ARPlaneAnchor else { return }

        /// Remove old node with given alignment
        removeNode(alignment: arPlaneAnchor.alignment)

        let newNode = makeNode(forAnchor: arPlaneAnchor)
        node.addChildNode(newNode)
    }
}
