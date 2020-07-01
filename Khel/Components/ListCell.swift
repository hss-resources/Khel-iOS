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

protocol ListCellDelegate: class {
    func shareList(_ list: List)
}

class ListCell: UITableViewCell {
    
    //TODO: Random generator (add to existing list)
    //TODO: add search bar
    
    private var list: List?
    weak private var delegate: ListCellDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let tagView = TagView()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .small)
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: smallConfiguration), for: .normal)
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
        
        frontView.add(shareButton, infoButton, lineView)
        shareButton.pinTo(top: 0, bottom: 0, left: 0)
        infoButton.pinTo(top: 0, bottom: 0, right: 0)
        lineView.pinTo(top: 0, bottom: 0)
        lineView.alignXAxis()
        shareButton.trailingAnchor.constraint(equalTo: lineView.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor).isActive = true
        
        return bgView
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
                
        let vStack = UIStackView(arrangedSubviews: [nameLabel, tagView, descriptionLabel])
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
        bgSquircle.pinTo(top: 8, bottom: 8, left: 16, right: 16)
        
        shareButton.addTarget(self, action: #selector(shareList), for: .touchUpInside)
        
    }
    
    func update(_ list: List, delegate: ListCellDelegate) {
        nameLabel.text = list.name
        descriptionLabel.text = list.enumeratedList
        self.delegate = delegate
        self.list = list
        tagView.update(Set(list.list.map { $0.category }))
    }
    
    @objc private func shareList() {
        if let list = list {
            delegate?.shareList(list)
        }
    }
    
}
