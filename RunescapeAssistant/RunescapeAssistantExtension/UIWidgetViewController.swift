//
//  UIWidgetViewController.swift
//  RunescapeAssistantExtension
//
//  Created by Edgars Vanags on 07/06/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import UIKit
import NotificationCenter

class UIWidgetViewController: UIViewController {
    
    @IBOutlet weak var placeholderLabel: UILabel!
    /// Compact View
    @IBOutlet weak var compactView: UIView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var currentLevel: UILabel!
    @IBOutlet weak var currentExperience: UILabel!
    @IBOutlet weak var gainedLevel: UILabel!
    @IBOutlet weak var gainedExperience: UILabel!
    /// Expanded View
    @IBOutlet weak var expandedView: UIView!
    @IBOutlet weak var horizontalView: UIView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var fifthImageView: UIImageView!
    @IBOutlet weak var sixthImageView: UIImageView!
    @IBOutlet weak var firstExperienceLabel: UILabel!
    @IBOutlet weak var secondExperienceLabel: UILabel!
    @IBOutlet weak var thirdExperienceLabel: UILabel!
    @IBOutlet weak var fourthExperienceLabel: UILabel!
    @IBOutlet weak var fifthExperienceLabel: UILabel!
    @IBOutlet weak var sixthExperienceLabel: UILabel!
    
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    private lazy var imageViews = [UIImageView]()
    private lazy var experienceLabels = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViews = [firstImageView, secondImageView, thirdImageView, fourthImageView, fifthImageView, sixthImageView]
        experienceLabels = [firstExperienceLabel, secondExperienceLabel, thirdExperienceLabel, fourthExperienceLabel, fifthExperienceLabel, sixthExperienceLabel]
        
        if let username = StorageManager.shared.unarchive(valueForKey: Constants.extensionUsername),
            let level = StorageManager.shared.unarchive(valueForKey: Constants.extensionLevel),
            let experience = StorageManager.shared.unarchive(valueForKey: Constants.extensionExperience) {
            
            playerName.text = username
            currentLevel.text = level
            currentExperience.text = experience
            
            adjustUserInterface(willDisplayData: true)
            
            if let delta = StorageManager.shared.unarchive(forKey: Constants.extensionCompetitorCache) {
                gainedLevel.text = String(delta.total.level)
                gainedExperience.text = delta.total.xp.formatExperience()
                
                for index in 0 ..< delta.skills.count {
                    imageViews[index].image = UIImage(named: delta.skills[index].name)
                    experienceLabels[index].text = delta.skills[index].xp.convertExperience()
                }
                
                extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            } else {
                extensionContext?.widgetLargestAvailableDisplayMode = .compact
            }
        } else {
            adjustUserInterface(willDisplayData: false)
            
            extensionContext?.widgetLargestAvailableDisplayMode = .compact
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeGesture(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    private func adjustUserInterface(willDisplayData isPopulated: Bool) {
        placeholderLabel.isHidden = isPopulated
        compactView.isHidden = !isPopulated
        expandedView.isHidden = !isPopulated
    }
}

// MARK: - NCWidgetProviding

extension UIWidgetViewController: NCWidgetProviding {
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .expanded:
            preferredContentSize = CGSize(width: 0, height: 185)
            
            UIView.animate(withDuration: 0.25) { [unowned self] in
                for imageView in self.imageViews {
                    imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                
                self.horizontalView.alpha = 1
            }
        case .compact:
            preferredContentSize = maxSize
            
            UIView.animate(withDuration: 0.25) { [unowned self] in
                for imageView in self.imageViews {
                    imageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }
                
                self.horizontalView.alpha = 0
            }
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        if let playerName = StorageManager.shared.unarchive(forKey: Constants.competitorCache)?.username {
            WebserviceManager.shared.fetch(playerName: playerName) { [unowned self] profile in
                guard let current = profile else {
                    self.adjustUserInterface(willDisplayData: false)
                    
                    return
                }
                
                self.playerName.text = StorageManager.shared.archive(current.username, forKey: Constants.extensionUsername)
                self.currentLevel.text = StorageManager.shared.archive(String(current.total.level), forKey: Constants.extensionLevel)
                self.currentExperience.text = StorageManager.shared.archive(current.total.xp.formatExperience(), forKey: Constants.extensionExperience)
                
                StorageManager.shared.difference(comparingTo: current) { profile in
                    guard let delta = profile else {
                        return
                    }
                    
                    self.gainedLevel.text = String(delta.total.level)
                    self.gainedExperience.text = delta.total.xp.formatExperience()
                    
                    delta.skills.sort { $0.xp > $1.xp }
                    delta.skills = Array(delta.skills.prefix(6))
                    
                    for index in 0 ..< 6 {
                        self.imageViews[index].image = delta.skills.indices.contains(index) ? UIImage(named: delta.skills[index].name) : nil
                        self.experienceLabels[index].text = delta.skills.indices.contains(index) ? delta.skills[index].xp.convertExperience() : nil
                    }
                    
                    self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
                    
                    StorageManager.shared.archive(delta, forKey: Constants.extensionCompetitorCache, completionHandler: nil)
                }
                
                self.adjustUserInterface(willDisplayData: true)
            }
        } else {
            adjustUserInterface(willDisplayData: false)
        }
        
        completionHandler(.newData)
    }
}

// MARK: - GestureRecognizerDelegate

extension UIWidgetViewController: GestureRecognizerDelegate {
    func didRecognizeGesture(_ sender: UIGestureRecognizer) {
        if sender is UITapGestureRecognizer {
            if let url = URL(string: "rachel://") {
                extensionContext?.open(url)
            }
        }
    }
}
