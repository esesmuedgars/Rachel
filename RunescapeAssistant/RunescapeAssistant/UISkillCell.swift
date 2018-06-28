//
//  UISkillCell.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 01/06/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import UIKit

class UISkillCell: UICollectionViewCell {
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let baseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = #colorLiteral(red: 0.1333333403, green: 0.1333333403, blue: 0.1333333403, alpha: 1)

        return view
    }()
    
    public let effectView: UIVisualEffectView =  {
        let effectView = UIVisualEffectView()
        effectView.effect = UIBlurEffect(style: .dark)
        effectView.alpha = 0
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        return effectView
    }()
    
    private var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.cornerRadius = 15
        
        configureViews()
        
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didRecognizeGesture(_:)))
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    private func configureViews() {
        insertSubview(baseView, belowSubview: contentView)
        addSubview(imageView)
        addSubview(effectView)
        
        baseView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        effectView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                baseView.widthAnchor.constraint(equalTo: widthAnchor, constant: -2),
                baseView.heightAnchor.constraint(equalTo: heightAnchor, constant: -2),
                baseView.centerXAnchor.constraint(equalTo: centerXAnchor),
                baseView.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                imageView.widthAnchor.constraint(equalToConstant: 40),
                imageView.heightAnchor.constraint(equalToConstant: 40),
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                effectView.widthAnchor.constraint(equalTo: widthAnchor),
                effectView.heightAnchor.constraint(equalTo: heightAnchor),
                effectView.centerXAnchor.constraint(equalTo: centerXAnchor),
                effectView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
        )
    }
    
    public func setImage(index: Int) {
        imageView.image = UIImage(named: Constants.runemetricsSkills[index].name)
    }
    
    public func configureShadow() {
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentView.layer.masksToBounds = true

        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: -5, height: 5)
        layer.shadowOpacity = 0.6
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    deinit {
        removeGestureRecognizer(longPressGestureRecognizer)
    }
}

// MARK: - GestureRecognizerDelegate

extension UISkillCell: GestureRecognizerDelegate {
    func didRecognizeGesture(_ sender: UIGestureRecognizer) {
        if let gesture = sender as? UILongPressGestureRecognizer {
            switch gesture.state {
            case .began:
                let point = gesture.location(in: self)
                print("Long press gesture at point: \(point)")
                
                UIView.animate(withDuration: 0.1) { [unowned self] in
                    self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    self.baseView.backgroundColor = #colorLiteral(red: 0.2300000042, green: 0.2300000042, blue: 0.2300000042, alpha: 1)
                }
            case .ended:
                print("Release at point: \(point)")
                
                UIView.animate(withDuration: 0.2) { [unowned self] in
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.baseView.backgroundColor = #colorLiteral(red: 0.1333333403, green: 0.1333333403, blue: 0.1333333403, alpha: 1)
                }
            default: break
            }
        }
    }
}
