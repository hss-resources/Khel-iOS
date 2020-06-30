//
//  ListManager.swift
//  Khel
//
//  Created by Janak Shah on 30/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit
import PlistManager
import StatusAlert

struct ListManager {
    
    static func add(_ khel: Khel, vc: UIViewController) {
        
        let allLists = PlistManager.get(Lists.self, from: String(describing: Lists.self)) ?? Lists()
        let ac = UIAlertController(title: khel.name, message: "Select a list to add this khel:", preferredStyle: .alert)

        allLists.payload.forEach { list in
            let action = UIAlertAction(title: list.name, style: .default) { _ in
                list.list.append(khel)
                PlistManager.save(allLists, plistName: String(describing: Lists.self))
                showAddedSuccessAlert()
            }
            ac.addAction(action)
        }

        let newList = UIAlertAction(title: "New list", style: .default) { _ in
            allLists.payload.append(List(name: "List \(allLists.payload.count + 1)", list: [khel]))
            PlistManager.save(allLists, plistName: String(describing: Lists.self))
            showAddedSuccessAlert()
        }
        ac.addAction(newList)

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        vc.present(ac, animated: true)
        
    }
    
    private static func showAddedSuccessAlert() {
        let statusAlert = StatusAlert()
        statusAlert.image = UIImage(systemName: "checkmark")
        statusAlert.title = "Added"
        statusAlert.appearance.tintColor = .label
        statusAlert.showInKeyWindow()
    }
    
}
