//
//  UINotificationView.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 31/05/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import UIKit

class UINotificationView: UIView {
    
    public let contentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.alpha = 0
        
        return view
    }()
    
    private let contentTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Latest changes"
        
        if let fontName = label.font?.fontName {
            label.font = UIFont(name: fontName, size: 22)
        }
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(UINotificationCell.self, forCellWithReuseIdentifier: "NotificationCell")
        collectionView.scrollIndicatorInsets.left = 15
        collectionView.scrollIndicatorInsets.right = 15
        collectionView.indicatorStyle = .black
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    public weak var delegate: UIViewController! {
        willSet {
            if let mainViewController = newValue as? UIMainViewController {
                collectionView.delegate = mainViewController
                collectionView.dataSource = mainViewController
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)

        drawNotificationView()
    }
    
    private func drawNotificationView() {
        let width: CGFloat = 275
        let height: CGFloat = 475
        contentView.frame = CGRect(x: center.x - width / 2, y: -height / 2, width: width, height: height)
        contentView.layer.cornerRadius = height / 25
        
        addSubview(contentView)
        contentView.addSubview(contentTitle)
        contentView.addSubview(collectionView)
        
        contentTitle.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                /// ContentView UILabel
                contentTitle.heightAnchor.constraint(equalToConstant: 50),
                contentTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                contentTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                contentTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                /// ContentView UICollectionView
                collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                collectionView.topAnchor.constraint(equalTo: contentTitle.bottomAnchor, constant: 20)
            ]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
