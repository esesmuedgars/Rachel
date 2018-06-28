//
//  Protocols.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 08/06/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol GestureRecognizerDelegate {
    func didRecognizeGesture(_ sender: UIGestureRecognizer)
}

@objc
protocol TodayExtensionApplicationDelegate {
    func didOpenURLScheme(_ sender: Notification)
}
