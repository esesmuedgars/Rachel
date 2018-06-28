//
//  DataModel.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 29/05/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import Foundation

class RunemetricsProfile: NSObject, Codable {
    var username: String
    var skills: [RunemetricsSkill]
    private var totalLevel: Int
    private var totalXP: Int
    
    var total: (level: Int, xp: Int) {
        get {
            return (totalLevel, totalXP)
        }
        set  {
            totalLevel = newValue.level
            totalXP = newValue.xp
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case username = "name"
        case totalLevel = "totalskill"
        case totalXP = "totalxp"
        case skills = "skillvalues"
    }
    
    private init(username: String, level: Int, xp: Int, skills: [RunemetricsSkill]) {
        self.username = username
        self.totalLevel = level
        self.totalXP = xp
        self.skills = skills
    }
}

extension RunemetricsProfile: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return RunemetricsProfile(username: username, level: totalLevel, xp: totalXP, skills: skills.map({ $0.copy() as! RunemetricsSkill }))
    }
}

class RunemetricsSkill: NSObject, Codable {
    private var identifier: Int
    var xp: Int
    var level: Int
    
    var id: Int {
        get {
            guard let index = Constants.runemetricsSkills.index(where: { return $0.id == identifier ? true : false }) else { return 0 }
            
            return index as Int
        }
    }
    
    var name: String {
        get {
            return Constants.runemetricsSkills[id].name
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case xp
        case level
    }
    
    private init(identifier: Int, level: Int, xp: Int) {
        self.identifier = identifier
        self.xp = xp
        self.level = level
    }
}

extension RunemetricsSkill: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return RunemetricsSkill(identifier: identifier, level: level, xp: xp)
    }
}
