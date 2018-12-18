//
//  ARObjectPlacementViewController.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit
import MultipeerConnectivity
import CoreBluetooth

final class ARObjectPlacementViewController: ARViewController {
    
    private let configuration = ARSurfaceDetectionConfiguration()
    
    private let viewModel = ObjectPlacementViewModel()
    
    private let bluetoothManager = CBCentralManager()
    
    private var geometryNumber: Int = 0
    
    private var p2pSession: P2PSession?
    
    private let numberOfGeometries = 9
    
    /// - SeeAlso: ARViewController.setupProperties()
    override func setupProperties() {
        p2pSession = P2PSession(receivedDataHandler: receivedData)
        sceneContainer.shareButton.isHidden = false
        sceneContainer.sceneView.delegate = self
    }
    
    /// - SeeAlso: ARViewController.setupCallbacks()
    override func setupCallbacks() {
        sceneContainer.shareButton.addTarget(self, action: #selector(userDidTapOnShare), for: .touchUpInside)
        sceneContainer.clearButton.addTarget(self, action: #selector(userDidTapClearButton), for: .touchUpInside)
    }
    
    /// - SeeAlso: ARViewController.runSession()
    override func runSession() {
        if let worldMap = viewModel.worldMap {
            configuration.initialWorldMap = worldMap
            sceneContainer.sceneView.session.run(configuration)
        } else {
            sceneContainer.sceneView.session.run(configuration)
        }
    }
    
    /// - SeeAlso: ARViewController.viewWillDisappear(animated:)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.saveWorldMap(forSession: sceneContainer.sceneView.session)
    }
    
    /// - SeeAlso: ARViewController.userDidTapClearButton()
    override func userDidTapClearButton() {
        sceneContainer.sceneView.session.pause()
        configuration.initialWorldMap = nil
        sceneContainer.sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
    
    @objc private func userDidTapOnShare() {
        guard let currentFrame = sceneContainer.sceneView.session.currentFrame else { return }
        
        switch currentFrame.worldMappingStatus {
        case .mapped:
            debugPrint("Mapped")
        case .limited:
            debugPrint("Limited")
        case .extending:
            debugPrint("Extending")
        case .notAvailable:
            debugPrint("Not Available")
        }
        guard bluetoothManager.state == .poweredOn else {
            present(UIAlertController.simple(title: "Please Turn Bluetooth On to share ARWorld"), animated: true)
            return
        }
        guard let p2pSession = p2pSession, !p2pSession.connectedPeers.isEmpty else {
            present(UIAlertController.simple(title: "There are no connected peers nearby"), animated: true)
            return
        }
        viewModel.sendWorldMapToPeers(session: sceneContainer.sceneView.session, p2pSession: p2pSession)
    }

    /// Detect touches on screen and create 3D object if hitTest has result
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let result = sceneContainer.sceneView.hitTest(touch.location(in: sceneContainer.sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitResult = result.last else { return }

        let anchor = ARAnchor(transform: hitResult.worldTransform)
        sceneContainer.sceneView.session.add(anchor: anchor)
    }
}

/// - SeeAlso: ARSCNViewDelegate
extension ARObjectPlacementViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        return createNodeWith3DObject()
    }
}

extension ARObjectPlacementViewController {
    
    private func createNodeWith3DObject() -> SCNNode {
        let geometry = generateGeometry()
        guard let text = geometry as? SCNText else {
            return createNode(withRotatingGeometry: geometry)
        }
        return createNode(withRotatingText: text)
    }
    
    private func createNode(withRotatingText text: SCNText) -> SCNNode {
        let node = SCNNode(geometry: text)
        
        let (minVec, maxVec) = node.boundingBox
        node.pivot = SCNMatrix4MakeTranslation((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0)

        sceneContainer.sceneView.scene.rootNode.addChildNode(node)

        let loop = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 5, z: 0, duration: 2.5))
        node.runAction(loop)
        
        return node
    }
    
    private func createNode(withRotatingGeometry geometry: SCNGeometry) -> SCNNode {
        let node = SCNNode(geometry: geometry)
        
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = #imageLiteral(resourceName: "Netguru_Green")
        
        node.geometry?.firstMaterial = material
        
        sceneContainer.sceneView.scene.rootNode.addChildNode(node)

        guard geometry is SCNPlane else {
            let action = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)
            let repeatedAction = SCNAction.repeatForever(action)
            node.runAction(repeatedAction, forKey: "ARTest.ARObjectPlacementViewController.rotation")
            return node
        }
        return node
    }
}

extension ARObjectPlacementViewController {
    
    private func generateGeometry() -> SCNGeometry {
        geometryNumber += 1
        
        if geometryNumber > numberOfGeometries {
            geometryNumber = 1
        }
        
        switch geometryNumber {
        case 1:
            return SCNSphere(radius: 0.05)
        case 2:
            return SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.04)
        case 3:
            return SCNTube(innerRadius: 0.06, outerRadius: 0.08, height: 0.12)
        case 4:
            return SCNPyramid(width: 0.08, height: 0.12, length: 0.08)
        case 5:
            return SCNCylinder(radius: 0.08, height: 0.04)
        case 6:
            return SCNCapsule(capRadius: 0.05, height: 0.08)
        case 7:
            return SCNTorus(ringRadius: 0.07, pipeRadius: 0.08)
        case 8:
            return SCNPlane(width: 0.5, height: 0.5)
        case 9:
            return generateSCNText()
        default:
            return SCNSphere(radius: 0.05)
        }
    }
    
    private func generateSCNText() -> SCNText {
        let text = SCNText(string: "Netguru", extrusionDepth: 0.05)
        text.font = UIFont (name: "Arial", size: 0.15)
        text.firstMaterial!.diffuse.contents = #colorLiteral(red: 0.01176470588, green: 0.8117647059, blue: 0.3450980392, alpha: 1)
        return text
    }
}

/// P2P Handler
extension ARObjectPlacementViewController {
    
    /// P2PSession Receiver
    func receivedData(_ data: Data, from peer: MCPeerID) {
        guard
            let classForKeyedARchiver = ARWorldMap.classForKeyedArchiver(),
            let unarchived = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [classForKeyedARchiver], from: data),
            let worldMap = unarchived as? ARWorldMap
        else {
            return
        }
        // Run the session with the received world map.
        let configuration = ARWorldTrackingConfiguration()
        configuration.initialWorldMap = worldMap
        sceneContainer.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}
