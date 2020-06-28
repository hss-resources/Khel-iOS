//
//  Khel.swift
//  Khel
//
//  Created by Janak Shah on 28/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit

struct Khel: Codable {
    let name: String
    let meaning: String
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
        
        var color: UIColor {
            switch self {
            case .pursuit: return UIColor.systemRed
            case .individual: return UIColor.systemOrange
            case .mandal: return UIColor.systemGreen
            case .team: return UIColor.systemBlue
            case .sittingDown: return UIColor.systemTeal
            case .dand: return UIColor.systemPink
            }
        }
    }
    
}
