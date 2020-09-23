//
//  SceneDelegate.swift
//  Khel
//
//  Created by Janak Shah on 28/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var tempContexts: Set<UIOpenURLContext>?
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        tempContexts = connectionOptions.urlContexts
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let url = URLContexts.first?.url else { return }
        
        if let scheme = url.scheme,
           scheme.localizedCaseInsensitiveCompare("khel.widget") == .orderedSame,
           let khelName = url.host {
            
            let allKhels: [Khel] = {
                if let url = Bundle.main.url(forResource: "khel", withExtension: "json") {
                    do {
                        let data = try Data(contentsOf: url)
                        let decoder = JSONDecoder()
                        return try decoder.decode([Khel].self, from: data)
                    } catch {
                        print("error:\(error)")
                    }
                }
                return []
            }()
            
            if let khel = allKhels.first(where: { $0.name.localizedCaseInsensitiveCompare(khelName) == .orderedSame }),
               var topController = window?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(UINavigationController(rootViewController: KhelDetailVC(khel, useType: .browseAll)), animated: true)
            }
            
        }
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        if let tempContexts = tempContexts {
            self.scene(scene, openURLContexts: tempContexts)
            self.tempContexts = nil
        }
    }
    
}
