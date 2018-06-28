//
//  Constants.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 29/05/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

struct Constants {
    static let runemetricsAPI = "https://apps.runescape.com/runemetrics/profile"
    
    static let todayExtensionIdentifier = "com.esesmuedgars.runescapeassistant.runescapeassistantextension"
    
    static let playerNameCharacterLimit = 12
    static let maximalLevel = 99
    
    static let personalCache = "ChachedPersonalRunescapeAccount"
    static let competitorCache = "CachedCompetitorRunescapeAccount"
    
    static let extensionUsername = "RachelTodayExtensionUsernameCache"
    static let extensionLevel = "RachelTodayExtensionLevelCache"
    static let extensionExperience = "RachelTodayExtensionExperienceCache"
    static let extensionCompetitorCache = "RachelTodayExtensionCachedCompetitorRunescapeAccount"
    
    static let runemetricsSkills: [(id: Int, name: String)] = [(0, "Attack"),
                                                               (3, "Constitution"),
                                                               (14, "Mining"),
                                                               (2, "Strength"),
                                                               (16, "Agility"),
                                                               (13, "Smithing"),
                                                               (1, "Defence"),
                                                               (15, "Herblore"),
                                                               (10, "Fishing"),
                                                               (4, "Ranged"),
                                                               (17, "Thieving"),
                                                               (7, "Cooking"),
                                                               (5, "Prayer"),
                                                               (12, "Crafting"),
                                                               (11, "Firemaking"),
                                                               (6, "Magic"),
                                                               (9, "Fletching"),
                                                               (8, "Woodcutting"),
                                                               (20, "Runecrafting"),
                                                               (18, "Slayer"),
                                                               (19, "Farming"),
                                                               (22, "Construction"),
                                                               (21, "Hunter"),
                                                               (23, "Summoning"),
                                                               (24, "Dungeoneering"),
                                                               (25, "Divination"),
                                                               (26, "Invention")
    ]
}
