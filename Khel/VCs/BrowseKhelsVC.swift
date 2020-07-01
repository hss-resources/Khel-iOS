//
//  BrowseKhelsVC.swift
//  Khel
//
//  Created by Janak Shah on 28/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit
import PlistManager
import JSSquircle

class BrowseKhelsVC: UIViewController {

    private let tableView = UITableView()
    private var topSpacing = NSLayoutConstraint()
    private let searchInput = UITextField()
    
    enum SortMethod: String, CaseIterable {
        case alphabetical = "A to Z"
        case random = "Randomise"
        case byCategory = "By category"
    }
    
    var sortMethod = SortMethod.alphabetical
    
    var selectedCategories: [Khel.Category] = []
    
    let allKhels: [Khel] = {
        if let url = Bundle.main.url(forResource: "khel", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                return try decoder.decode([Khel].self, from: data)
            } catch {
                print("error:\(error)")
            }
        }
        return []
    }()
    
    private func filterKhels() {
        var temp = allKhels
        
        switch sortMethod {
        case .alphabetical:
            temp.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending }
        case .random:
            temp.shuffle()
        case .byCategory:
            break
        }
        
        if !selectedCategories.isEmpty {
            temp = temp.filter { selectedCategories.contains($0.category)}
        }
        
        filteredKhels = temp
    }
    
    var filteredKhels: [Khel] = []
    
    var searchedKhels: [Khel] {
        guard let searchText = searchInput.text,
            !searchText.isEmpty else { return filteredKhels }
        return filteredKhels.filter { $0.name.contains(searchText) }
    }
    
    private lazy var filterView: UIView = {
        let filterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        
        let switches: [UIView] = Khel.Category.allCases.map({
            let label = UILabel()
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            label.text = $0.rawValue
            let onSwtich = UISwitch()
            onSwtich.tag = Khel.Category.allCases.firstIndex(of: $0) ?? 0
            onSwtich.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
            return UIStackView(arrangedSubviews: [label, onSwtich])
        })
        
        let searchLabel = UILabel()
        searchLabel.text = "Search:"
        searchLabel.font = .systemFont(ofSize: 13, weight: .bold)
        searchLabel.textColor = .secondaryLabel
        
        let searchInputSquircle = Squircle()
        searchInputSquircle.add(searchInput)
        searchInput.pinTo(top: 8, bottom: 8, left: 8, right: 8)
        searchInput.font = .systemFont(ofSize: 15, weight: .medium)
        searchInput.placeholder = "Search"
        searchInput.clearButtonMode = .always
        searchInput.autocorrectionType = .no
        searchInput.spellCheckingType = .no
        searchInput.smartDashesType = .no
        searchInput.smartQuotesType = .no
        searchInput.returnKeyType = .done
        searchInput.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchInput.delegate = self
        searchInputSquircle.backgroundColor = .systemBackground
        searchInputSquircle.cornerRadius = 8
        
        let sortLabel = UILabel()
        sortLabel.text = "Sort method:"
        sortLabel.font = .systemFont(ofSize: 13, weight: .bold)
        sortLabel.textColor = .secondaryLabel
        
        let segementedControl = UISegmentedControl(items: SortMethod.allCases.map { $0.rawValue })
        segementedControl.selectedSegmentIndex = SortMethod.allCases.firstIndex(of: sortMethod) ?? 0
        segementedControl.addTarget(self, action: #selector(sortMethodChanged(_:)), for: .valueChanged)
        
        let categoryLabel = UILabel()
        categoryLabel.text = "Categories:"
        categoryLabel.font = .systemFont(ofSize: 13, weight: .bold)
        categoryLabel.textColor = .secondaryLabel
        
        let filterViews = [searchLabel, searchInputSquircle, sortLabel, segementedControl, categoryLabel]
        
        let vStack = UIStackView(arrangedSubviews: filterViews + switches)
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .equalSpacing
        vStack.spacing = 8
        
        filterView.backgroundColor = .secondarySystemBackground
        filterView.add(vStack)
        vStack.pinTo(top: 8, bottom: 8, left: 24, right: 24)
        filterView.alpha = 0
        return filterView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Browse all"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(toggleFilterDrawer))
        
        view.add(tableView, filterView)
        tableView.pinTo(left: 0, right: 0)
        filterView.pinTo(left: 0, right: 0)
        topSpacing = tableView.topAnchor.constraint(equalTo: view.topAnchor)
        topSpacing.isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: filterView.bottomAnchor).isActive = true
                
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(KhelCell.self, forCellReuseIdentifier: KhelCell.UseType.browseAll.rawValue)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        tableView.backgroundColor = .secondarySystemBackground
        view.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = UITableView.automaticDimension
        
        filterKhels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc private func toggleFilterDrawer() {
        dismissKeyboard()
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            guard let self = self else { return }
            self.topSpacing.constant = self.topSpacing.constant == 0 ? self.filterView.bounds.height : 0
            self.filterView.alpha = self.topSpacing.constant == 0 ? 0 : 1
            self.view.layoutIfNeeded()
            }, completion: { [weak self] (_) in
                if self?.topSpacing.constant == 0 {
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(self?.toggleFilterDrawer))
                } else {
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle.fill"), style: .plain, target: self, action: #selector(self?.toggleFilterDrawer))
                }
        })
    }
    
    @objc private func switchToggled(_ sender: UISwitch) {
        let category = Khel.Category.allCases[sender.tag]
        if selectedCategories.contains(category) {
            selectedCategories.removeAll { $0 == category }
        } else {
            selectedCategories.append(category)
        }
        filterKhels()
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
    }
    
    @objc private func sortMethodChanged(_ sender: UISegmentedControl) {
        sortMethod = SortMethod.allCases[sender.selectedSegmentIndex]
        filterKhels()
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
    }

}

extension BrowseKhelsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedKhels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: KhelCell.UseType.browseAll.rawValue, for: indexPath) as? KhelCell else { return UITableViewCell() }
        cell.update(searchedKhels[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(UINavigationController(rootViewController: KhelDetailVC(searchedKhels[indexPath.row], useType: .browseAll)), animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }

}

extension BrowseKhelsVC: KhelCellDelegate {
    func handleLeftButton(_ khel: Khel) {
        ListManager.add(khel, vc: self)
    }
    
}

extension BrowseKhelsVC: UITextFieldDelegate {
    
    @objc private func textFieldDidChange() {
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
