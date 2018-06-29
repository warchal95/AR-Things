//
//  ARSceneContainerView.swift
//  AR Test
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit

final class ARSceneContainerView: BaseView {

    internal var sceneView: ARSCNView = {
        let sceneView = ARSCNView()

        sceneView.showsStatistics = true
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        sceneView.automaticallyUpdatesLighting = true
        sceneView.translatesAutoresizingMaskIntoConstraints = false

        return sceneView
    }()

    internal var clearButton: UIButton = {
        let button = UIButton()

        button.layer.cornerRadius = 5.0
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    internal var torchButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Torch", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    internal var shareButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        
        return button
    }()
    
    override func setupLayout() {
        [sceneView, clearButton, torchButton, shareButton].forEach(addSubview)

        sceneView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        sceneView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        sceneView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true

        clearButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        clearButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        clearButton.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
        
        torchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        torchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        torchButton.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
        torchButton.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
        
        shareButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        shareButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
    }
}
