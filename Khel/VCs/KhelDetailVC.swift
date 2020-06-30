//
//  KhelDetailVC.swift
//  Khel
//
//  Created by Janak Shah on 28/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit
import JSSquircle
import SafariServices

class KhelDetailVC: UIViewController {
    
    enum UseType: String {
        case browseAll
        case alreadyInList
    }
    
    //================================================================================
    // MARK: Private Properties
    //================================================================================
    
    private let khel: Khel
    private let useType: UseType
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.insetsLayoutMarginsFromSafeArea = true
        return scrollView
    }()
    
    //================================================================================
    // MARK: Initialisation
    //================================================================================
    
    init(_ khel: Khel, useType: UseType) {
        self.khel = khel
        self.useType = useType
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
        
        let topSquircle = Squircle()
        topSquircle.add(vStack)
        vStack.pinTo(top: 16, bottom: 16, left: 16, right: 16)
        topSquircle.cornerRadius = 16
        topSquircle.backgroundColor = .systemBackground
        
        let togetherStack = UIStackView(arrangedSubviews: [topSquircle, bottomView()])
        togetherStack.axis = .vertical
        togetherStack.alignment = .fill
        togetherStack.distribution = .equalSpacing
        togetherStack.spacing = 16
        
        view.add(scrollView)
        scrollView.pinTo(left: 0, right: 0)
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        scrollView.add(togetherStack)
        togetherStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8).isActive = true
        togetherStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: togetherStack.trailingAnchor, constant: 16).isActive = true
        togetherStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
        togetherStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 8).isActive = true
        
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
    
    @objc private func addToList() {
        ListManager.add(khel, vc: self)
    }
    
    @objc private func shareKhelInfo() {
        let items = ["\(khel.name) - \(khel.category.rawValue)\n\nMeaning:\n\(khel.meaning)\n\nAim:\n\(khel.aim)\n\nDescription:\n\(khel.description)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @objc private func contactSupport() {
        if let url = URL(string: "https://appktchn.com/contact-us/") {
            let config = SFSafariViewController.Configuration()
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
        
    // MARK: - Helpers
    
    private func bottomView() -> UIView {
        let bottomVStack = UIStackView()
        bottomVStack.axis = .vertical
        bottomVStack.distribution = .equalSpacing
        bottomVStack.alignment = .fill
        bottomVStack.spacing = 12
        
        switch useType {
        case .alreadyInList:
            break
        case .browseAll:
            let addToListButton = UIButton()
            addToListButton.setTitle("Add to list", for: .normal)
            addToListButton.backgroundColor = .secondarySystemBackground
            styleButton(addToListButton, systemImage: "plus")
            addToListButton.addTarget(self, action: #selector(addToList), for: .touchUpInside)
            bottomVStack.addArrangedSubview(addToListButton)
        }
        
        let shareButton = UIButton()
        shareButton.setTitle("Share khel info", for: .normal)
        shareButton.backgroundColor = .secondarySystemBackground
        styleButton(shareButton, systemImage: "square.and.arrow.up")
        shareButton.addTarget(self, action: #selector(shareKhelInfo), for: .touchUpInside)
        bottomVStack.addArrangedSubview(shareButton)

        let somethingWrongButton = UIButton()
        somethingWrongButton.setTitle("Spotted something wrong?", for: .normal)
        somethingWrongButton.backgroundColor = .secondarySystemBackground
        styleButton(somethingWrongButton, systemImage: "envelope")
        somethingWrongButton.addTarget(self, action: #selector(contactSupport), for: .touchUpInside)
        bottomVStack.addArrangedSubview(somethingWrongButton)

        let bottomSquircle = Squircle()
        bottomSquircle.add(bottomVStack)
        bottomVStack.pinTo(top: 16, bottom: 16, left: 16, right: 16)
        bottomSquircle.cornerRadius = 16
        bottomSquircle.backgroundColor = .systemBackground
        
        return bottomSquircle
    }
    
    private func styleButton(_ button: UIButton, systemImage: String) {
        button.layer.cornerRadius = 8
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 13, weight: .semibold))
        button.setImage(UIImage(systemName: systemImage, withConfiguration: config), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.tintColor = .label
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        button.pinHeight(32)
    }
}

//================================================================================
// MARK: Extensions
//================================================================================
