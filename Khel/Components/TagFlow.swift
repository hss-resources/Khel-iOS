//
//  TagFlow.swift
//  Khel
//
//  Created by Janak Shah on 29/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit
import JSSquircle

class TagView: UIView {
    
    private let vStack = UIStackView()
    private let padding: CGFloat = 8
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .equalSpacing
        vStack.spacing = padding
        
        add(vStack)
        vStack.pinTo(top: 0, bottom: 0, left: 0, right: 0)
        
    }
    
    func update(_ tags: [Khel.Category]) {
        
        let maxRowWidth = UIScreen.main.bounds.width - (16*4)
        var runningWidth: CGFloat = 0
        
        vStack.addArrangedSubview(hStack())
        
        tags.forEach {
            
            let label = UILabel()
            label.font = .systemFont(ofSize: 11, weight: .bold)
            label.textColor = .systemBackground
            label.text = $0.rawValue
            
            let labelContainer = Squircle()
            labelContainer.translatesAutoresizingMaskIntoConstraints = false
            labelContainer.add(label)
            labelContainer.backgroundColor = $0.color
            labelContainer.cornerRadius = 6
            label.pinTo(top: 3, bottom: 3, left: 6, right: 6)
            
            labelContainer.layoutIfNeeded()
            runningWidth += (labelContainer.bounds.width + padding)
            
            if runningWidth <= maxRowWidth,
                let hStack = vStack.arrangedSubviews.last as? UIStackView {
                hStack.addArrangedSubview(labelContainer)
            } else {
                runningWidth = labelContainer.bounds.width + padding
                vStack.addArrangedSubview(hStack())
                if runningWidth <= maxRowWidth,
                    let hStack = vStack.arrangedSubviews.last as? UIStackView {
                    hStack.addArrangedSubview(labelContainer)
                }
            }
            
        }
        
    }
    
    private func hStack() -> UIStackView {
        let hStack = UIStackView()
        hStack.spacing = 8
        return hStack
    }
    
}
