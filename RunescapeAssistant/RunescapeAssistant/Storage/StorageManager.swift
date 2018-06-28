//
//  StorageManager.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 05/06/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import Foundation

struct StorageManager {
    static let shared = StorageManager()
    
    private let defaults = UserDefaults(suiteName: "group.com.esesmuedgars.rachel.application")
    
    func archive(_ profile: RunemetricsProfile, forKey key: String, completionHandler: SuccessCompletion?) {
        do {
            let data = try JSONEncoder().encode(profile)
            defaults?.set(data, forKey: key)
            
            completionHandler?(true)
        } catch {
            completionHandler?(false)
        }
    }
    
    func archive(_ string: String, forKey key: String) -> String {
        defaults?.set(string, forKey: key)
        
        return string
    }
    
    func unarchive(forKey key: String) -> RunemetricsProfile? {
        guard let data = defaults?.data(forKey: key) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(RunemetricsProfile.self, from: data)
        } catch {
            return nil
        }
    }
    
    func unarchive(valueForKey key: String) -> String? {
        return defaults?.string(forKey: key)
    }
    
    func remove(valueForKey key: String) {
        defaults?.removeObject(forKey: key)
    }
    
    func difference(comparingTo profile: RunemetricsProfile, completionHandler: @escaping ProfileCompletion) {
        DispatchQueue.global(qos: .utility).async {
            if let cached = self.unarchive(forKey: Constants.competitorCache),
                profile.total.xp > cached.total.xp {
                let delta = profile.copy() as! RunemetricsProfile
                
                delta.total.level -= cached.total.level
                delta.total.xp -= cached.total.xp
                delta.skills.forEach { skill in
                    if let cached = cached.skills.first(where: { $0.id == skill.id }) {
                        
                        skill.level -= cached.level
                        skill.xp -= cached.xp
                    }
                }
                
                delta.skills = delta.skills.filter({ $0.xp != 0 })
                
                DispatchQueue.main.async {
                    completionHandler(delta)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
}
