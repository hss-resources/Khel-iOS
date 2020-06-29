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

class ListDetailVC: UITableViewController {

    private let list: List
    private let index: Int
    
    init(_ list: List, index: Int) {
        self.list = list
        self.index = index
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = list.name
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editListName))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(close))
        
        tableView.register(KhelCell.self, forCellReuseIdentifier: String(describing: KhelCell.self))
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        tableView.backgroundColor = .secondarySystemBackground
    }
    
    @objc private func editListName() {
        let ac = UIAlertController(title: "Rename list:", message: nil, preferredStyle: .alert)
        ac.addTextField { [weak self] (textField) in
            textField.placeholder = self?.list.name
        }

        let submitAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] action in
            guard let newName = ac?.textFields?[0].text,
            let self = self else { return }
            let allLists = PlistManager.get(Lists.self, from: String(describing: Lists.self)) ?? Lists()
            let thisList = allLists.payload[self.index]
            thisList.name = newName
            self.title = newName
            PlistManager.save(allLists, plistName: String(describing: Lists.self))
        }

        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc private func close() {
        if let presentationVC = navigationController?.presentationController {
            presentationVC.delegate?.presentationControllerWillDismiss?(presentationVC)
        }
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: KhelCell.self), for: indexPath) as? KhelCell else { return UITableViewCell() }
        cell.update(list.list[indexPath.row], delegate: self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(UINavigationController(rootViewController: KhelDetailVC(list.list[indexPath.row])), animated: true)
    }

}

extension ListDetailVC: KhelCellDelegate {
    
    //TODO: Change to remove from list
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
