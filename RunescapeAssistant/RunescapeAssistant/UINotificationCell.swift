//
//  UINotificationCell.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 05/06/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import UIKit

class UINotificationCell: UICollectionViewCell {
    private var contentBody: UIView = {
        let view = UIView()
        view.backgroundColor = .groupTableViewBackground
        
        return view
    }()
    
    private let horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8392156959, green: 0.8392156959, blue: 0.8392156959, alpha: 1)
        
        return view
    }()
    
    private let imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1333333403, green: 0.1333333403, blue: 0.1333333403, alpha: 1)
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = #colorLiteral(red: 0.1333333403, green: 0.1333333403, blue: 0.1333333403, alpha: 1)
        
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureViews()
    }
    
    private func configureViews() {
        contentView.addSubview(contentBody)
        contentBody.addSubview(horizontalLine)
        contentBody.addSubview(stackView)
        contentView.addSubview(imageContainer)
        imageContainer.addSubview(imageView)

        contentBody.translatesAutoresizingMaskIntoConstraints = false
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            /// ContentBody
            contentBody.widthAnchor.constraint(equalTo: widthAnchor),
            contentBody.topAnchor.constraint(equalTo: topAnchor, constant: 35),
            contentBody.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentBody.centerXAnchor.constraint(equalTo: centerXAnchor),
            /// ContentBody UIView
            horizontalLine.widthAnchor.constraint(equalTo: contentBody.widthAnchor),
            horizontalLine.heightAnchor.constraint(equalToConstant: 1),
            horizontalLine.topAnchor.constraint(equalTo: contentBody.topAnchor),
            horizontalLine.centerXAnchor.constraint(equalTo: contentBody.centerXAnchor),
            /// ContentBody UIStackView
            stackView.widthAnchor.constraint(equalTo: contentBody.widthAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: contentBody.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: contentBody.bottomAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: contentBody.centerXAnchor),
            /// UIView
            imageContainer.widthAnchor.constraint(equalToConstant: 70),
            imageContainer.heightAnchor.constraint(equalToConstant: 70),
            imageContainer.topAnchor.constraint(equalTo: topAnchor),
            imageContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            /// UIView UIImageView
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor)
            ]
        )
        
        imageContainer.layer.cornerRadius = 35
    }
    
    public func configure(_ profile: RunemetricsProfile?, latestChanges difference: RunemetricsProfile?, index: Int) {
        guard let profile = profile, let difference = difference else {
            return
        }
        
        stackView.clearArrangedSubviews()
        
        let delta = difference.skills[index]
        let current = profile.skills[delta.id]
        
        imageView.image = UIImage(named: current.name)
        
        let labels = [
            drawLabel(String(format: "Current level: %ld", current.level)),
            drawLabel(String(format: "Current experience: %@", current.xp.formatExperience(truncate: true))),
            drawLabel(String(format: "Levels gained: %ld", delta.level)),
            drawLabel(String(format: "Experience gained: %@", delta.xp.formatExperience(truncate: true))),
        ]
        
        for label in labels {
            stackView.addArrangedSubview(label)
        }
    }
    
    private func drawLabel(_ text: String?) -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.text = text
        
        if let fontName = label.font?.fontName {
            label.font = UIFont(name: fontName, size: 16)
        }
        
        return label
    }
}
