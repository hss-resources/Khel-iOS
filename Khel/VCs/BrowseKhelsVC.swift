//
//  BrowseKhelsVC.swift
//  Khel
//
//  Created by Janak Shah on 28/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit
import PlistManager
import StatusAlert

class BrowseKhelsVC: UITableViewController {

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
    
    var filterOpen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Browse all"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(toggleFilterDrawer))
        
        tableView.register(KhelCell.self, forCellReuseIdentifier: String(describing: KhelCell.self))
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        filterKhels()
    }
    
    @objc private func toggleFilterDrawer() {
        filterOpen = !filterOpen
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
        if filterOpen {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle.fill"), style: .plain, target: self, action: #selector(toggleFilterDrawer))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(toggleFilterDrawer))
        }
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

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard filterOpen else {
            let header = UIView()
            header.pinHeight(1)
            return header
        }
        
        let filterView = UIView()
        
        let switches: [UIView] = Khel.Category.allCases.map({
            let label = UILabel()
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            label.text = $0.rawValue
            let onSwtich = UISwitch()
            onSwtich.isOn = selectedCategories.contains($0)
            onSwtich.tag = Khel.Category.allCases.firstIndex(of: $0) ?? 0
            onSwtich.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
            return UIStackView(arrangedSubviews: [label, onSwtich])
        })
        
        let sortLabel = UILabel()
        sortLabel.text = "Sort method:"
        sortLabel.font = .systemFont(ofSize: 13, weight: .bold)
        sortLabel.textColor = .secondaryLabel
        
        let categoryLabel = UILabel()
        categoryLabel.text = "Categories:"
        categoryLabel.font = .systemFont(ofSize: 13, weight: .bold)
        categoryLabel.textColor = .secondaryLabel
        
        let filterViews = [sortLabel, categoryLabel]
        
        let vStack = UIStackView(arrangedSubviews: filterViews + switches)
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .equalSpacing
        vStack.spacing = 8
        
        filterView.backgroundColor = .secondarySystemBackground
        filterView.add(vStack)
        vStack.pinTo(top: 8, bottom: 8, left: 24, right: 24)
        return filterView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredKhels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: KhelCell.self), for: indexPath) as? KhelCell else { return UITableViewCell() }
        cell.update(filteredKhels[indexPath.row], delegate: self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(KhelDetailVC(filteredKhels[indexPath.row]), animated: true)
    }

}

extension BrowseKhelsVC: KhelCellDelegate {
    func addToList(_ khel: Khel) {
        let allLists = PlistManager.get(Lists.self, from: String(describing: Lists.self)) ?? Lists()
        let ac = UIAlertController(title: khel.name, message: "Select a list to add this khel:", preferredStyle: .alert)
        
        allLists.payload.forEach { list in
            let action = UIAlertAction(title: list.name, style: .default) { _ in
                list.list.append(khel)
                PlistManager.save(allLists, plistName: String(describing: Lists.self))
            }
            ac.addAction(action)
        }
        
        let newList = UIAlertAction(title: "New list", style: .default) { _ in
            allLists.payload.append(List(name: "List \(allLists.payload.count + 1)", list: [khel]))
            PlistManager.save(allLists, plistName: String(describing: Lists.self))
        }
        ac.addAction(newList)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
}
