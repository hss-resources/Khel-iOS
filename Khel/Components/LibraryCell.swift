//
//  KhelCell.swift
//  Khel
//
//  Created by Janak Shah on 28/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit
import JSSquircle
import LessAutolayoutBoilerplate

class LibraryCell: UITableViewCell {
    
    weak var delegate: KhelCellDelegate?
    private var khel: Khel?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .systemBackground
        return label
    }()
    
    private let categoryContainer = Squircle()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        
        selectionStyle = .none
        
        let bgSquircle = Squircle()
        bgSquircle.cornerRadius = 16
        bgSquircle.backgroundColor = .systemBackground
        
        categoryContainer.cornerRadius = 6
        categoryContainer.add(categoryLabel)
        categoryLabel.pinTo(top: 3, bottom: 3, left: 6, right: 6)
        
        let vStack = UIStackView(arrangedSubviews: [nameLabel, categoryContainer, descriptionLabel])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .equalSpacing
        vStack.spacing = 8
        
        bgSquircle.add(vStack)
        vStack.pinTo(top: 16, bottom: 16, left: 16, right: 16)
        
        let iconSquircle = Squircle()
        let icon = UIImageView(image: UIImage(systemName: "tray.fill"))
        icon.tintColor = .systemBlue
        iconSquircle.add(icon)
        iconSquircle.cornerRadius = 8
        iconSquircle.backgroundColor = .secondarySystemBackground
        icon.pinTo(top: 8, bottom: 8, left: 8, right: 8)
        bgSquircle.add(iconSquircle)
        iconSquircle.pinTo(top: 16, right: 16)
        
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        contentView.add(bgSquircle)
        bgSquircle.pinTo(top: 8, bottom: 8, left: 16, right: 16)
    }
    
    func update(_ name: String, author: String, description: String) {
        nameLabel.text = name
        descriptionLabel.text = description
        categoryLabel.text = author
        categoryContainer.backgroundColor = .systemBlue
    }
    
}
