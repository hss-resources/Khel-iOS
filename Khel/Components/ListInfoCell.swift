//
//  DeleteCell.swift
//  Khel
//
//  Created by Janak Shah on 30/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit

class ListInfoCell: UITableViewCell {
    
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
        let label = UILabel()
        label.numberOfLines = 0
        label.text = """
Rename this list using the edit button above.
Add more khels from the "Browse All" section.
Hold, drag & drop to change the order of this list.
"""
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        contentView.add(label)
        label.pinTo(top: 8, bottom: 8, left: 16, right: 16)
        
    }

}
