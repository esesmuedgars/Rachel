//
//  UIMainViewController.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 29/05/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import UIKit

let kUsername = "Xeldz" // TODO: Remove

class UIMainViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var skillCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var notificationView: UINotificationView?
    
    private var personalProfile: RunemetricsProfile?
    private var competitorProfile: RunemetricsProfile?
    private var competitorDifference: RunemetricsProfile?
    
    private var gestureRecognizer: UIPanGestureRecognizer!
    private var panOrigin: CGPoint!

    private var transition: UICustomTransition!
    
    @IBAction func textFieldDidEndOnExit(_ sender: UITextField) {
        if let playerName = sender.text {
            requestSkills(for: playerName) { [unowned self] profile in
                StorageManager.shared.archive(profile, forKey: Constants.personalCache) { [unowned self] success in
                    if !success {
                        self.alert(title: "Oops, something went wrong!", message: "Personal profile data has not been cached successfully")
                    }
                }
                
                self.personalProfile = profile
                self.textField.text = profile.username
            }
        }
    }
    
    @IBAction func didTapMenuButton(_ sender: UIButton) {
        print("Temporary implementation") // TODO: Remove
        requestSkills(for: kUsername) { profile in
            StorageManager.shared.archive(profile, forKey: Constants.competitorCache) { [unowned self] success in
                if !success {
                    self.alert(title: "Oops, something went wrong!", message: "Competitor profile data has not been cached successfully")
                }
            }
            
            self.competitorProfile = profile
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let playerName = StorageManager.shared.unarchive(forKey: Constants.personalCache)?.username {
            textField.text = playerName

            requestSkills(for: playerName) { [unowned self] profile in
                self.personalProfile = profile
                self.textField.text = profile.username
            }
        }

        if let playerName = StorageManager.shared.unarchive(forKey: Constants.competitorCache)?.username {
            requestSkills(for: playerName) { [unowned self] profile in
                self.competitorProfile = profile
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(didOpenURLScheme(_:)), name: .UITodayExtensionDidOpenApplication, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .UITodayExtensionDidOpenApplication, object: nil)
    }
    
    private func simulateExperienceChanges(_ profile: RunemetricsProfile) {
        profile.total.xp += 11250000
        profile.total.level += 12
        profile.skills.forEach({
            if $0.id == 18 {
                /// Runecrafting (225K)
                $0.xp += (225000 * 10)
                $0.level += 2
            } else if $0.id == 26 {
                /// Invention (10M 25K)
                $0.xp += (10025000 * 10)
                $0.level += 9
            } else if $0.id == 19 {
                /// Slayer (1M)
                $0.xp += (1000000 * 10)
                $0.level += 1
            }
        })
        
        print("Simulated experience changes for:", profile.username)
    }
    
    private func alert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func presentNotificationView(withLatest profile: RunemetricsProfile) {
        StorageManager.shared.difference(comparingTo: profile) { [unowned self] profile in
            guard let profile = profile else {
                return
            }
            
            // FIXME: Here so collectionView does not need reloading, adjust, maybe can be put at the end
            self.competitorDifference = profile
            
            /// self.cacheManager.unarchive(forKey: Constants.competitorCache)   #cached profile
            /// self.competitorProfile                                           #latest profile
            /// self.competitorDifference & profile                              #difference in levels and experience
            
            self.notificationView = UINotificationView(frame: self.view.frame)
            self.notificationView?.delegate = self
            self.view.addSubview(self.notificationView!)
            
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .beginFromCurrentState, animations: {
                self.notificationView?.contentView.center = self.view.center
                self.notificationView?.contentView.alpha = 1
            }, completion: { _ in
                self.panOrigin = self.notificationView?.contentView.frame.origin
                self.gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didRecognizeGesture(_:)))
                self.notificationView?.contentView.addGestureRecognizer(self.gestureRecognizer)
            })
        }
    }
    
    private func requestSkills(for playerName: String, completionHandler completion: @escaping (RunemetricsProfile) -> ()) {
        spinner.startAnimating()
        
        WebserviceManager.shared.fetch(playerName: playerName) { [unowned self] profile in
            guard let profile = profile else {
                return
            }
            
            completion(profile)
            
            self.skillCollectionView.reloadData()
            self.spinner.stopAnimating()
        }
    }
    
    private func returnNotificationView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [.beginFromCurrentState, .allowUserInteraction], animations: { [unowned self] in
            self.notificationView?.contentView.center = self.view.center
        })
    }
    
    private func dismissNotificationView(y offset: CGFloat) {
        let y = offset < 0 ? -notificationView!.contentView.frame.height : notificationView!.frame.height
        
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            self.notificationView?.contentView.frame.origin = CGPoint(x: self.panOrigin.x, y: y)
//            self.notificationView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        }, completion: { [weak self] _ in
            self?.notificationView?.removeFromSuperview()
            
            if let profile = self?.competitorProfile {
                StorageManager.shared.archive(profile, forKey: Constants.competitorCache, completionHandler: nil)
                StorageManager.shared.remove(valueForKey: Constants.extensionCompetitorCache)
            }
        })
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension UIMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(skillCollectionView) {
            return Constants.runemetricsSkills.count
        } else {
            return competitorDifference?.skills.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.isEqual(skillCollectionView),
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCell", for: indexPath) as? UISkillCell {
            cell.setImage(index: indexPath.row)
            cell.configureShadow()
            
            return cell
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationCell", for: indexPath) as? UINotificationCell {
            cell.configure(competitorProfile, latestChanges: competitorDifference, index: indexPath.row)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.isEqual(skillCollectionView) {
            let margin = (collectionView.frame.width - 80) / 3
            return CGSize(width: margin, height: margin)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UISkillCell {
            let origin = collectionView.convert(cell.frame.origin, to: view)
            let frame = CGRect(origin: origin , size: cell.frame.size)
            
            transition = UICustomTransition(frame)
            transition.cornerRadius = cell.layer.cornerRadius
            transition.image = cell.imageView.image
            transition.indexPath = indexPath
            
            if let skillViewController = self.storyboard?.instantiateViewController(withIdentifier: "SkillViewController") as? UISkillViewController {
                skillViewController.transitioningDelegate = self
                skillViewController.modalPresentationStyle = .custom
                
                self.present(skillViewController, animated: true)
                
                cell.alpha = 0.5 // TODO: Adjust
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension UIMainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let playerName = textField.text else {
            return false
        }

        return playerName.count + string.count - range.length <= Constants.playerNameCharacterLimit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let playerName = textField.text else {
            return false
        }
        
        return playerName.count <= Constants.playerNameCharacterLimit
    }
}

// MARK: - GestureRecognizerDelegate

extension UIMainViewController: GestureRecognizerDelegate {
    func didRecognizeGesture(_ sender: UIGestureRecognizer) {
        guard let notificationView = notificationView else {
            return
        }
        
        if let gesture = sender as? UIPanGestureRecognizer {
            let point = gesture.translation(in: view)
            let y = point.y + panOrigin.y
            let offset = abs((y + notificationView.contentView.frame.size.height / 2) - view.frame.size.height / 2)
            
            notificationView.contentView.frame.origin = CGPoint(x: panOrigin.x, y: y)
        
//            let alpha = max(1 - (offset / 200), 0.3)
//            notificationView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)

            if gesture.state == .ended || gesture.state == .cancelled {
                offset > view.frame.height / 4 ? dismissNotificationView(y: point.y) : returnNotificationView()
            }
        }
    }
}

// MARK: - TodayExtensionApplicationDelegate

extension UIMainViewController: TodayExtensionApplicationDelegate {
    func didOpenURLScheme(_ sender: Notification) {
        if let playerName = StorageManager.shared.unarchive(forKey: Constants.competitorCache)?.username {
            requestSkills(for: playerName) { [unowned self] profile in
                self.competitorProfile = profile
                
                self.presentNotificationView(withLatest: profile)
            }
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension UIMainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        
        return transition
    }
}


