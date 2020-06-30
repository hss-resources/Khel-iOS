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
        
        title = khel.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(close))
        
        let categoryLabel = UILabel()
        categoryLabel.font = .systemFont(ofSize: 11, weight: .bold)
        categoryLabel.textColor = .systemBackground
        categoryLabel.text = khel.category.rawValue
        let categoryContainer = Squircle()
        categoryContainer.cornerRadius = 6
        categoryContainer.backgroundColor = khel.category.color
        categoryContainer.add(categoryLabel)
        categoryLabel.pinTo(top: 3, bottom: 3, left: 6, right: 6)
        
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
        
        let squircle = Squircle()
        squircle.add(vStack)
        vStack.pinTo(top: 16, bottom: 16, left: 16, right: 16)
        squircle.cornerRadius = 16
        squircle.backgroundColor = .systemBackground
        
        view.add(scrollView)
        scrollView.pinTo(left: 0, right: 0)
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        scrollView.add(squircle)
        squircle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8).isActive = true
        squircle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: squircle.trailingAnchor, constant: 16).isActive = true
        squircle.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
        squircle.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 8).isActive = true
        
        view.backgroundColor = .secondarySystemBackground
        
    }
    
    @objc private func close() {
        if let presentationVC = navigationController?.presentationController {
            presentationVC.delegate?.presentationControllerWillDismiss?(presentationVC)
        }
        dismiss(animated: true)
    }
    
    //================================================================================
    // MARK: Actions
    //================================================================================
    
    //TODO: Add share, add to list, spotted something wrong? buttons

}

//================================================================================
// MARK: Extensions
//================================================================================
