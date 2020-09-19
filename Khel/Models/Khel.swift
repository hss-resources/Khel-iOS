//
//  Khel.swift
//  Khel
//
//  Created by Janak Shah on 28/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit

struct Khel: Codable, Equatable {
    
    let name: String
    let meaning: String?
    let aim: String
    let description: String
    let category: Category
    
    enum Category: String, Codable, CaseIterable {
        case pursuit = "Pursuit"
        case individual = "Individual"
        case mandal = "Mandal"
        case team = "Team"
        case sittingDown = "Sitting down"
        case dand = "Dand"
        case ekhel = "E-Khel"
        
        var color: UIColor {
            switch self {
            case .pursuit: return UIColor.systemRed
            case .individual: return UIColor.systemOrange
            case .mandal: return UIColor.systemGreen
            case .team: return UIColor.systemBlue
            case .sittingDown: return UIColor.systemTeal
            case .dand: return UIColor.systemPink
            case .ekhel: return UIColor.systemYellow
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case meaning
        case aim
        case description
        case category
    }
    
    internal init(name: String, meaning: String?, aim: String, description: String, category: Khel.Category) {
        self.name = name
        self.meaning = meaning
        self.aim = aim
        self.description = description
        self.category = category
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        aim = try container.decode(String.self, forKey: .aim)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(Category.self, forKey: .category)
        
        guard let rawMeaning = try? container.decode(String.self, forKey: .meaning),
            rawMeaning != name,
            !rawMeaning.isEmpty else {
                meaning = nil
                return
        }
        
        meaning = rawMeaning
        
    }
    
}
