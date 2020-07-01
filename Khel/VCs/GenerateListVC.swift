//
//  KhelDetailVC.swift
//  Khel
//
//  Created by Janak Shah on 28/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit
import JSSquircle
import PlistManager
import StatusAlert

class GenerateListVC: UIViewController {
    
    //================================================================================
    // MARK: Private Properties
    //================================================================================
        
    private weak var delegate: (UIViewController & UIAdaptivePresentationControllerDelegate)?
    private let currentCount: Int
    private let numberOfLabel = UILabel()
    private let stepper = UIStepper()
    private let listNameInput = UITextField()
    private var scrollViewToBottom = NSLayoutConstraint()
    private var index: Int?
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.insetsLayoutMarginsFromSafeArea = true
        return scrollView
    }()
    
    private let switches: [UISwitch] = {
        return Khel.Category.allCases.map { _ in UISwitch() }
    }()
    
    //================================================================================
    // MARK: Init
    //================================================================================
    
    init(_ currentCount: Int, delegate: (UIViewController & UIAdaptivePresentationControllerDelegate)? = nil, index: Int? = nil) {
        self.currentCount = currentCount
        self.delegate = delegate
        self.index = index
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShallShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShallHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        title = self.index == nil ? "Generate list" : "Generate more"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(close))
        
        let switchRows: [UIView] = Khel.Category.allCases.enumerated().map({ (index, category) in
            let label = UILabel()
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            label.text = category.rawValue
            let onSwtich = switches[index]
            return UIStackView(arrangedSubviews: [label, onSwtich])
        })
        
        let listNameLabel = UILabel()
        listNameLabel.text = "List name:"
        listNameLabel.font = .systemFont(ofSize: 13, weight: .bold)
        listNameLabel.textColor = .secondaryLabel
        
        let nameInputSquircle = Squircle()
        nameInputSquircle.add(listNameInput)
        listNameInput.pinTo(top: 8, bottom: 8, left: 8, right: 8)
        listNameInput.font = .systemFont(ofSize: 15, weight: .medium)
        listNameInput.placeholder = "List name"
        listNameInput.delegate = self
        nameInputSquircle.backgroundColor = .secondarySystemBackground
        nameInputSquircle.cornerRadius = 8
        
        let sortLabel = UILabel()
        sortLabel.text = "Number of khels:"
        sortLabel.font = .systemFont(ofSize: 13, weight: .bold)
        sortLabel.textColor = .secondaryLabel
        
        stepper.value = 10
        stepper.minimumValue = 1
        stepper.addTarget(self, action: #selector(stepperChanged(_:)), for: .valueChanged)
        numberOfLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        numberOfLabel.text = String(Int(stepper.value))
        
        let categoryLabel = UILabel()
        categoryLabel.text = "From these categories:"
        categoryLabel.font = .systemFont(ofSize: 13, weight: .bold)
        categoryLabel.textColor = .secondaryLabel
        
        var filterViews = [sortLabel, UIStackView(arrangedSubviews: [numberOfLabel, stepper]), categoryLabel]
        if index == nil {
            filterViews.insert(contentsOf: [listNameLabel, nameInputSquircle], at: 0)
        }
        
        let vStack = UIStackView(arrangedSubviews: filterViews + switchRows)
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .equalSpacing
        vStack.spacing = 8
                
        let topSquircle = Squircle()
        topSquircle.add(vStack)
        vStack.pinTo(top: 16, bottom: 16, left: 16, right: 16)
        topSquircle.cornerRadius = 16
        topSquircle.backgroundColor = .systemBackground
        
        let togetherStack = UIStackView(arrangedSubviews: [topSquircle, generateButton()])
        togetherStack.axis = .vertical
        togetherStack.alignment = .fill
        togetherStack.distribution = .equalSpacing
        togetherStack.spacing = 16
        
        view.add(scrollView)
        scrollView.pinTo(left: 0, right: 0)
        scrollViewToBottom = view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        scrollViewToBottom.isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        scrollView.add(togetherStack)
        togetherStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8).isActive = true
        togetherStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: togetherStack.trailingAnchor, constant: 16).isActive = true
        togetherStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: togetherStack.bottomAnchor, constant: 16).isActive = true
        
        view.backgroundColor = .secondarySystemBackground
        
        listNameInput.becomeFirstResponder()
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
    
    //================================================================================
    // MARK: Actions
    //================================================================================
        
    @objc private func generate() {
        
        guard var name = listNameInput.text else { return }
        if name.isEmpty {
            name = "List \(currentCount+1)"
        }
        
        let selectedCategories: [Khel.Category] = switches.enumerated().compactMap { (index, switc) in
                return switc.isOn ? Khel.Category.allCases[index] : nil
        }
        
        if let url = Bundle.main.url(forResource: "khel", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let allKhels = try decoder.decode([Khel].self, from: data)
                let shuffledKhels = allKhels.shuffled()
                
                var khelsList = [Khel]()
                
                if selectedCategories.isEmpty {
                    khelsList = Array(shuffledKhels[0..<Int(stepper.value)])
                } else {
                    var index = 0
                    while khelsList.count < Int(stepper.value) {
                        
                        if shuffledKhels.count-1 == index {
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(systemName: "checkmark")
                            statusAlert.title = "Max added"
                            statusAlert.appearance.tintColor = .label
                            statusAlert.showInKeyWindow()
                            break
                        }
                        
                        if selectedCategories.contains(shuffledKhels[index].category) { khelsList.append(shuffledKhels[index]) }
                        index += 1
                    }
                }
                
                let allLists = PlistManager.get(Lists.self, from: String(describing: Lists.self)) ?? Lists()
                if let index = self.index {
                    allLists.payload[index].list += khelsList
                } else {
                    allLists.payload.append(List(name: name, list: khelsList))
                }
                PlistManager.save(allLists, plistName: String(describing: Lists.self))
                
                let statusAlert = StatusAlert()
                statusAlert.image = UIImage(systemName: "checkmark")
                statusAlert.title = "Generated"
                statusAlert.appearance.tintColor = .label
                statusAlert.showInKeyWindow()
                
                if let presentationVC = navigationController?.presentationController {
                    presentationVC.delegate?.presentationControllerWillDismiss?(presentationVC)
                }
                dismiss(animated: true) { [weak self] in
                    guard let self = self,
                        let list = PlistManager.get(Lists.self, from: String(describing: Lists.self))?.payload[self.currentCount],
                        self.index == nil else { return }
                    let nav = UINavigationController(rootViewController: ListDetailVC(list, index: self.currentCount))
                    nav.presentationController?.delegate = self.delegate
                    self.delegate?.present(nav, animated: true)
                }
                
            } catch {
                print("error:\(error)")
            }
        }
        
    }
    
    @objc private func stepperChanged(_ stepper: UIStepper) {
        numberOfLabel.text = String(Int(stepper.value))
    }
    
    // MARK: - Helpers
    
    private func generateButton() -> UIView {
        let generateButton = UIButton()
        generateButton.setTitle("Generate", for: .normal)
        generateButton.backgroundColor = .systemBackground
        generateButton.addTarget(self, action: #selector(generate), for: .touchUpInside)
        generateButton.layer.cornerRadius = 8
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .bold))
        generateButton.setImage(UIImage(systemName: "plus.app.fill", withConfiguration: config), for: .normal)
        generateButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        generateButton.setTitleColor(.label, for: .normal)
        generateButton.tintColor = .label
        generateButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        generateButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        generateButton.pinHeight(42)
        return generateButton
    }
    
    @objc private func keyboardShallShow(_ notification: Notification) {
        let rect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        scrollViewToBottom.constant = rect.height
    }
    
    @objc private func keyboardShallHide(_ notification: Notification) {
        scrollViewToBottom.constant = 0
    }

}

//================================================================================
// MARK: Extensions
//================================================================================

extension GenerateListVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
