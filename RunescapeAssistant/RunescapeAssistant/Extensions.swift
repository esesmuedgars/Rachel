//
//  Extensions.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 06/06/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import Foundation
import UIKit

extension String {
    fileprivate func insert(separator: String, step: Int) -> String {
        var result = String()
        let characters: [Character] = self.reversed()
        
        stride(from: 0, to: count, by: step).forEach { index in
            result += String(characters[index ..< min(index + step, count)])
            if index + step < count {
                result += separator
            }
        }
        
        return String(result.reversed())
    }
    
    fileprivate func convert() -> String {
        var suffix = String()
        
        switch count {
        case let c where c > 9:
            suffix = "B"
        case let c where c > 6:
            suffix = "M"
        case let c where c > 3:
            suffix = "k"
        default:
            break
        }

        let components = insert(separator: ".", step: 3).split(separator: ".")
        var result = String(components.first!)
        
        if components.count > 1 {
            result.append(".\(components[1].prefix(1))")
        }
        
        return result.appending(suffix)
    }
}

extension Int {
    func formatExperience(separator: String = " ", every step: Int = 3, truncate: Bool = false) -> String {
        var experience = String(self)
        
        if truncate {
            experience = String(experience.dropLast())
        }
        
        return experience.insert(separator: separator, step: step)
    }
    
    func convertExperience() -> String {
        let experience = String(self).dropLast()
        
        return String(experience).convert()
    }
}

extension UIStackView {
    func clearArrangedSubviews() {
        for subview in arrangedSubviews {
            NSLayoutConstraint.deactivate(subview.constraints)
            removeArrangedSubview(subview)
        }
    }
}

extension Notification.Name {
    static let UITodayExtensionDidOpenApplication = Notification.Name(rawValue: "TodayExtensionDidOpenApplication")
}
