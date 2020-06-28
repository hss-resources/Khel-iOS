//
//  Extension+UIViewController.swift
//  Khel
//
//  Created by Janak Shah on 28/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addCloseButton() {
        let closeButton = UIButton()
        closeButton.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        view.add(closeButton)
        closeButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor).isActive = true
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeButton.pinTo(top: 8, right: 8)
    }
    
    @objc private func closeAction() {
        dismiss(animated: true)
    }

}
