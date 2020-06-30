//
//  DeleteCell.swift
//  Khel
//
//  Created by Janak Shah on 30/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit

class DeleteCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        selectionStyle = .none
        let button = UIButton()
        button.setTitle("Delete entire list", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 13, weight: .semibold))
        button.setImage(UIImage(systemName: "trash", withConfiguration: config), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        button.pinHeight(32)
        button.isUserInteractionEnabled = false
        contentView.add(button)
        button.pinTo(top: 8, bottom: 8, left: 16, right: 16)
        
    }

}
