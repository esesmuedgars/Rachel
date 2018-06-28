//
//  UISkillViewController.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 12/06/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import UIKit

class UISkillViewController: UIViewController {

    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var animationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor)
            ]
        )
        
        animationView.layer.borderWidth = 2
        animationView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        animationView.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { [unowned self] in
            self.animationView.frame.size = CGSize(width: 150, height: 150)
            self.animationView.center = self.imageViewContainer.center
            self.animationView.layer.cornerRadius = 75
        }) { _ in
            // TODO: Animate bars
        }
    }
    
    @IBAction func shouldCancelViewController(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {  [unowned self] in
            self.animationView.frame.size = self.imageViewContainer.frame.size
            self.animationView.center = self.imageViewContainer.center
            self.animationView.layer.cornerRadius = self.imageViewContainer.layer.cornerRadius
        }) { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
}
