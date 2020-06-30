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

protocol KhelCellDelegate: class {
    func handleLeftButton(_ khel: Khel)
}

class KhelCell: UITableViewCell {

    enum UseType: String {
        case browseAll
        case alreadyInList
    }
    
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
        return label
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.tintColor = .secondaryLabel
        button.backgroundColor = .tertiarySystemBackground
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        return button
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        button.setTitle("More info", for: .normal)
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .small)
        button.setImage(UIImage(systemName: "info.circle", withConfiguration: smallConfiguration), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.tintColor = .secondaryLabel
        button.backgroundColor = .tertiarySystemBackground
        button.isUserInteractionEnabled = false
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        return button
    }()
    
    private lazy var linedView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .tertiaryLabel
        bgView.pinHeight(33)
        let frontView = UIView()
        frontView.backgroundColor = .systemBackground
        bgView.add(frontView)
        frontView.pinTo(top: 1, bottom: 0, left: 0, right: 0)
        
        let lineView = UIView()
        lineView.backgroundColor = .tertiaryLabel
        lineView.pinWidth(1)
        
        frontView.add(leftButton, infoButton, lineView)
        leftButton.pinTo(top: 0, bottom: 0, left: 0)
        infoButton.pinTo(top: 0, bottom: 0, right: 0)
        lineView.pinTo(top: 0, bottom: 0)
        lineView.alignXAxis()
        leftButton.trailingAnchor.constraint(equalTo: lineView.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor).isActive = true
        
        return bgView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit(UseType(rawValue: reuseIdentifier ?? "browseAll") ?? .browseAll)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit(UseType(rawValue: reuseIdentifier ?? "browseAll") ?? .browseAll)
    }
    
    private func customInit(_ reuseId: UseType) {
        
        switch reuseId {
        case .browseAll:
            leftButton.setTitle("Add to list", for: .normal)
            let smallConfiguration = UIImage.SymbolConfiguration(scale: .small)
            leftButton.setImage(UIImage(systemName: "plus.circle", withConfiguration: smallConfiguration), for: .normal)
        case .alreadyInList:
            leftButton.setTitle("Remove", for: .normal)
            let smallConfiguration = UIImage.SymbolConfiguration(scale: .small)
            leftButton.setImage(UIImage(systemName: "trash", withConfiguration: smallConfiguration), for: .normal)
        }
        
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
        
        bgSquircle.add(vStack, linedView)
        vStack.pinTo(top: 16, left: 16, right: 16)
        linedView.pinTo(bottom: 0, left: 0, right: 0)
        linedView.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 16).isActive = true
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.add(bgSquircle)
        bgSquircle.pinTo(top: 16, bottom: 0, left: 16, right: 16)
        
        leftButton.addTarget(self, action: #selector(addToListAction), for: .touchUpInside)
    }
    
    func update(_ khel: Khel, delegate: KhelCellDelegate) {
        nameLabel.text = khel.name
        
        let descriptionText = NSMutableAttributedString(string: "Aim: ", attributes: Theme.attr(13, weight: .bold, color: .label))
        descriptionText.append(NSAttributedString(string: khel.aim, attributes: Theme.attr(13, weight: .medium, color: .secondaryLabel)))
        descriptionLabel.attributedText = descriptionText
        
        categoryLabel.text = khel.category.rawValue
        categoryContainer.backgroundColor = khel.category.color
        
        self.delegate = delegate
        self.khel = khel
    }
    
    @objc private func addToListAction() {
        if let khel = khel {
            delegate?.handleLeftButton(khel)
        }
    }
    
}
