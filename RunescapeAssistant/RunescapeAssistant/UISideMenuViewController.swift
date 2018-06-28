//
//  UISideMenuViewController.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 15/06/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import UIKit

@objc
protocol SideMenuDelegate: class {
}

class UISideMenuViewController: UIViewController {
    
    private var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeDidPan(_:)))
        screenEdgePanGestureRecognizer.edges = .left
        view.addGestureRecognizer(screenEdgePanGestureRecognizer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.removeGestureRecognizer(screenEdgePanGestureRecognizer)
    }
    
    @objc
    private func screenEdgeDidPan(_ sender: UIGestureRecognizer) {
        print(self, #function)
    }
}

// MARK: - SideMenuDelegate

extension UISideMenuViewController: SideMenuDelegate {
    
}
