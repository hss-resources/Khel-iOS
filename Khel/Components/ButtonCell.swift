//
//  DeleteCell.swift
//  Khel
//
//  Created by Janak Shah on 30/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    private let button = UIButton()
    
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
        button.layer.cornerRadius = 8
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        button.pinHeight(32)
        button.isUserInteractionEnabled = false
        contentView.add(button)
        button.pinTo(top: 0, bottom: 0, left: 16, right: 16)
        
    }
    
    func update(_ text: String, systemImage: String, bgColor: UIColor, font: UIFont, textColor: UIColor) {
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = font
        let config = UIImage.SymbolConfiguration(font: font)
        button.setTitleColor(textColor, for: .normal)
        button.tintColor = textColor
        button.setImage(UIImage(systemName: systemImage, withConfiguration: config), for: .normal)
        button.backgroundColor = bgColor
    }

}
