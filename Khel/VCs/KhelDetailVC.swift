//
//  KhelDetailVC.swift
//  Khel
//
//  Created by Janak Shah on 28/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit
import JSSquircle

class KhelDetailVC: UIViewController {
    
    //================================================================================
    // MARK: Private Properties
    //================================================================================
    
    private let khel: Khel
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.insetsLayoutMarginsFromSafeArea = true
        return scrollView
    }()
    
    //================================================================================
    // MARK: Public Properties
    //================================================================================
    

    
    //================================================================================
    // MARK: Initialisation
    //================================================================================
    
    init(_ khel: Khel) {
        self.khel = khel
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //================================================================================
    // MARK: Lifecycle
    //================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoryLabel = UILabel()
        categoryLabel.font = .systemFont(ofSize: 11, weight: .bold)
        categoryLabel.textColor = .systemBackground
        categoryLabel.text = khel.category.rawValue
        let categoryContainer = Squircle()
        categoryContainer.cornerRadius = 6
        categoryContainer.backgroundColor = khel.category.color
        categoryContainer.add(categoryLabel)
        categoryLabel.pinTo(top: 3, bottom: 3, left: 6, right: 6)
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.text = khel.name
        
        let meaningLabel = UILabel()
        meaningLabel.font = .systemFont(ofSize: 13, weight: .bold)
        meaningLabel.numberOfLines = 0
        meaningLabel.text = "Meaning:"
        
        let meaning = UILabel()
        meaning.font = .systemFont(ofSize: 13, weight: .medium)
        meaning.textColor = .secondaryLabel
        meaning.numberOfLines = 0
        meaning.text = khel.meaning
        
        let aimLabel = UILabel()
        aimLabel.font = .systemFont(ofSize: 13, weight: .bold)
        aimLabel.numberOfLines = 0
        aimLabel.text = "Aim:"
        
        let aim = UILabel()
        aim.font = .systemFont(ofSize: 13, weight: .medium)
        aim.textColor = .secondaryLabel
        aim.numberOfLines = 0
        aim.text = khel.aim
        
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .bold)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Description:"
        
        let description = UILabel()
        description.font = .systemFont(ofSize: 13, weight: .medium)
        description.textColor = .secondaryLabel
        description.numberOfLines = 0
        description.text = khel.description
        
        let vStack = UIStackView(arrangedSubviews: [categoryContainer,
                                                    titleLabel,
                                                    meaningLabel,
                                                    meaning,
                                                    aimLabel,
                                                    aim,
                                                    descriptionLabel,
                                                    description])
        vStack.alignment = .leading
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.spacing = 8
        
        view.add(scrollView)
        scrollView.pinTo(left: 0, right: 0)
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        scrollView.add(vStack)
        vStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        vStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: 20).isActive = true
        vStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true
        vStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 30).isActive = true
        
        view.backgroundColor = .secondarySystemBackground
        
        addCloseButton()
        
    }
    
    //================================================================================
    // MARK: Public Interface
    //================================================================================
    
    
    
    //================================================================================
    // MARK: Actions
    //================================================================================
    
    

    //================================================================================
    // MARK: Helpers
    //================================================================================
    
    
    
}

//================================================================================
// MARK: Extensions
//================================================================================
