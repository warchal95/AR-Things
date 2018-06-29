//
//  ARViewController.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit

class ARViewController: UIViewController {
    
    internal let sceneContainer = ARSceneContainerView()
    
    private var isTorchTurnedOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupProperties()
        setupCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        runSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneContainer.sceneView.session.pause()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Concrete
    private func setupView() {
        view.addSubview(sceneContainer)
        
        sceneContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        sceneContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        sceneContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        sceneContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
    }
    
    internal func setupCallbacks() {
        sceneContainer.clearButton.addTarget(self, action: #selector(userDidTapClearButton), for: .touchUpInside)
        sceneContainer.torchButton.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)
    }
    
    @objc func userDidTapClearButton() {
        sceneContainer.sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
    }
    
    @objc func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        try? device.lockForConfiguration()
        
        if isTorchTurnedOn == false {
            device.torchMode = .on
        } else {
            device.torchMode = .off
        }
        device.unlockForConfiguration()
        isTorchTurnedOn = !isTorchTurnedOn
    }
    
    // MARK: Abstract
    /// Sets up the properties of `self`. Called automatically on `viewDidLoad()`.
    internal func setupProperties() { }
    
    /// Run session with concrete configuration
    internal func runSession() { }
}
