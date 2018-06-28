//
//  UICustomTransition.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 12/06/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import UIKit

class UICustomTransition: NSObject {
    enum TransitionMode {
        case present
        case dismiss
    }
    
    private var duration: TimeInterval!
    private var point: CGPoint!
    
    public var transitionMode: TransitionMode = .present
    public var backgroundColor: UIColor? = #colorLiteral(red: 0.1333333403, green: 0.1333333403, blue: 0.1333333403, alpha: 1)
    public var cornerRadius: CGFloat = 0
    public var image: UIImage?
    public var indexPath: IndexPath!
    
    private let view: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let maskView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    init(_ frame: CGRect) {
        let cgRect = CGRect(origin: frame.origin, size: CGSize(width: frame.width.rounded(), height: frame.height.rounded()))
        
        self.view.frame = cgRect
        self.maskView.frame = cgRect
        
        self.point = view.center
    }
    
    private func configureViews(contextContainer containerView: UIView, destinationView: UIView) {
        containerView.addSubview(destinationView)
        
        maskView.backgroundColor = backgroundColor
        maskView.layer.cornerRadius = cornerRadius
        destinationView.mask = maskView
        
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        containerView.addSubview(view)
        
        imageView.image = image
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
    }
    
    private func configureViewController(_ viewController: UISkillViewController?, animationCenter center: CGPoint) {
        guard let controller = viewController else {
            return
        }
        
        controller.imageView.image = image
        
        controller.imageViewContainer.frame.size = view.frame.size
        controller.imageViewContainer.center = center
        controller.imageViewContainer.layer.cornerRadius = view.frame.size.height / 2
        
        controller.animationView.frame.size = view.frame.size
        controller.animationView.center = center
        controller.animationView.layer.cornerRadius = view.frame.size.height / 2
    }
}

extension UICustomTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        switch transitionMode {
        case .present:
            if let viewController = transitionContext.viewController(forKey: .to) {
                let center = CGPoint(x: viewController.view.center.x, y: 170)
                duration = max(0.2, Double((view.frame.origin.y) / 1800))
                
                configureViews(contextContainer: containerView, destinationView: viewController.view)
                configureViewController(viewController as? UISkillViewController, animationCenter: center)
                
                UIView.animate(withDuration: duration, animations: { [unowned self] in
                    self.view.layer.cornerRadius = self.view.frame.height / 2
                    self.view.center = center
                    
                    self.maskView.layer.cornerRadius = self.view.frame.height / 2
                    self.maskView.center = center
                }) { [weak self] _ in
                    UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut, .preferredFramesPerSecond60], animations: {
                        let bound = sqrt(pow(viewController.view.frame.height, 2) + pow(viewController.view.frame.width, 2))
                        
                        self?.maskView.frame.size = CGSize(width: bound, height: bound)
                        self?.maskView.center = viewController.view.center
                        self?.maskView.layer.cornerRadius = bound / 2
                    }) { success in
                        self?.view.removeFromSuperview()
                        
                        transitionContext.completeTransition(success)
                    }
                }
            }
        case .dismiss:
            if let viewController = transitionContext.viewController(forKey: .from) {
                transitionContext.containerView.addSubview(view)
                
                UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn, .preferredFramesPerSecond60], animations: { [unowned self] in
                    self.maskView.frame.size = self.view.frame.size
                    self.maskView.center = self.view.center
                    self.maskView.layer.cornerRadius = self.view.layer.cornerRadius
                }) { [unowned self] _ in
                    UIView.animate(withDuration: self.duration, animations: {
                        self.view.layer.cornerRadius = self.cornerRadius
                        self.view.center = self.point
                        
                        self.maskView.layer.cornerRadius = self.cornerRadius
                        self.maskView.center = self.point
                    }, completion: { success in
                        if let viewController = transitionContext.viewController(forKey: .to) as? UIMainViewController {
                            viewController.skillCollectionView.cellForItem(at: self.indexPath)?.alpha = 1
                        }
                        
                        viewController.removeFromParentViewController()
                        
                        transitionContext.completeTransition(success)
                    })
                }
            }
        }
    }
}

