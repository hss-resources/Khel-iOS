//
//  BrowseKhelsVC.swift
//  Khel
//
//  Created by Janak Shah on 28/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit

class BrowseKhelsVC: UITableViewController {

    enum SortMethod: String {
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
        
        let vStack = UIStackView(arrangedSubviews: Khel.Category.allCases.map({
            let label = UILabel()
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            label.text = $0.rawValue
            let onSwtich = UISwitch()
            onSwtich.isOn = selectedCategories.contains($0)
            onSwtich.tag = Khel.Category.allCases.firstIndex(of: $0) ?? 0
            onSwtich.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
            return UIStackView(arrangedSubviews: [label, onSwtich])
        }))
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
        print("add \(khel.name)")
    }
    
    func moreInfo(_ khel: Khel) {
        present(KhelDetailVC(khel), animated: true)
    }
    
    
}
