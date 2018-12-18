//
//  ARViewController.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit

class ARViewController: UIViewController {
    
    /// Container with AR Scene view
    let sceneContainer = ARSceneContainerView()
    
    private var isTorchTurnedOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupProperties()
        setupCallbacks()
    }
    
    /// - SeeAlso: UIViewController.viewWillAppear(animated:)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runSession()
    }
    
    /// - SeeAlso: UIViewController.viewWillDisappear(animated:)
    override func viewWillDisappear(_ animated: Bool) {
        sceneContainer.sceneView.session.pause()
    }
    
    /// - SeeAlso: UIViewController.prefersStatusBarHidden
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupView() {
        view.addSubview(sceneContainer)
        
        NSLayoutConstraint.activate([
            sceneContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sceneContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            sceneContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sceneContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
    }
    
    /// Informs that user did tap on clear button
    @objc func userDidTapClearButton() {
        sceneContainer.sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
    }
    
    @objc private func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        try? device.lockForConfiguration()
        device.torchMode = isTorchTurnedOn ? .off : .on
        device.unlockForConfiguration()
        isTorchTurnedOn = !isTorchTurnedOn
    }
    
    /// Sets up the properties of `self`. Called automatically on `viewDidLoad()`.
    func setupProperties() { }
    
    /// Setup Callbacks. Can be overridden
    func setupCallbacks() {
        sceneContainer.clearButton.addTarget(self, action: #selector(userDidTapClearButton), for: .touchUpInside)
        sceneContainer.torchButton.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)
    }
    
    /// Run session with concrete configuration
    func runSession() { }
}
