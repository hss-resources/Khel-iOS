//
//  BrowseKhelsVC.swift
//  Khel
//
//  Created by Janak Shah on 28/06/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import UIKit
import PlistManager

class ListsVC: UITableViewController {
    
    enum Section: Int, CaseIterable {
        case generate
        case existing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My lists"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(ListCell.self, forCellReuseIdentifier: String(describing: ListCell.self))
        tableView.register(GenerateListCell.self, forCellReuseIdentifier: String(describing: GenerateListCell.self))
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch Section(rawValue: section) {
        case .generate:
            return 1
        case .existing:
            return PlistManager.get(Lists.self, from: String(describing: Lists.self))?.payload.count ?? 0
        case .none:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch Section(rawValue: indexPath.section) {
        case .generate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GenerateListCell.self), for: indexPath) as? GenerateListCell else { return UITableViewCell() }
            return cell
        case .existing:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListCell.self), for: indexPath) as? ListCell,
                let list = PlistManager.get(Lists.self, from: String(describing: Lists.self))?.payload[indexPath.row] else { return UITableViewCell() }
            cell.update(list, delegate: self)
            return cell
        case .none:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .generate:
            let nav = UINavigationController(rootViewController: GenerateListVC(PlistManager.get(Lists.self, from: String(describing: Lists.self))?.payload.count ?? 0, delegate: self))
            nav.presentationController?.delegate = self
            present(nav, animated: true)
        case .existing:
            guard let list = PlistManager.get(Lists.self, from: String(describing: Lists.self))?.payload[indexPath.row] else { return }
            let nav = UINavigationController(rootViewController: ListDetailVC(list, index: indexPath.row))
            nav.presentationController?.delegate = self
            present(nav, animated: true)
        case .none:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Section(rawValue: section) {
        case .existing, .none:
            return 0
        case .generate:
            return 8
        }
    }

}

extension ListsVC: ListCellDelegate {
    func shareList(_ list: List) {
        let items = ["\(list.name)\n\(list.enumeratedList)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}

extension ListsVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        tableView.reloadData()
    }
}
