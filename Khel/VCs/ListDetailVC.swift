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
    
    enum Section: Int, CaseIterable {
        case info
        case khels
        case generateMore
        case share
        case dangerZone
    }
    
    private var list: List
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
        
        tableView.register(ListInfoCell.self, forCellReuseIdentifier: String(describing: ListInfoCell.self))
        tableView.register(KhelCell.self, forCellReuseIdentifier: KhelCell.UseType.alreadyInList.rawValue)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: String(describing: ButtonCell.self))
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        tableView.backgroundColor = .secondarySystemBackground
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }
    
    @objc private func editListName() {
        let ac = UIAlertController(title: "Rename list:", message: nil, preferredStyle: .alert)
        ac.addTextField { [weak self] (textField) in
            textField.placeholder = self?.list.name
        }
        
        let submitAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text,
                !newName.isEmpty,
                let self = self else { return }
            let allLists = PlistManager.get(Lists.self, from: String(describing: Lists.self)) ?? Lists()
            let thisList = allLists.payload[self.index]
            thisList.name = newName
            self.title = newName
            PlistManager.save(allLists, plistName: String(describing: Lists.self))
            
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(systemName: "checkmark")
            statusAlert.title = "Renamed"
            statusAlert.appearance.tintColor = .label
            statusAlert.showInKeyWindow()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if Section.allCases[section] == .dangerZone {
            let view = UIView()
            view.backgroundColor = .secondarySystemBackground
            
            let label = UILabel()
            label.text = "Danger zone!"
            label.font = .systemFont(ofSize: 13, weight: .semibold)
            label.textColor = .systemRed
            
            view.add(label)
            label.alignYAxis()
            label.pinTo(left: 16, right: 16)
            
            return view
        }
        let view = UIView()
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch Section(rawValue: section) {
        case .info: return 0
        case .khels: return 8
        case .generateMore: return 16
        case .share: return 8
        case .dangerZone: return 0
        case .none: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Section(rawValue: section) {
        case .info: return 0
        case .khels: return 8
        case .generateMore: return 0
        case .share: return 0
        case .dangerZone: return 30
        case .none: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch Section(rawValue: section) {
        case .info: return 1
        case .khels: return list.list.count
        case .generateMore: return 1
        case .share: return 1
        case .dangerZone: return 1
        case .none: return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch Section(rawValue: indexPath.section) {
        case .info:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListInfoCell.self), for: indexPath) as? ListInfoCell else { return UITableViewCell() }
            cell.updateText("""
            Rename this list using the edit button above.
            Hold, drag & drop to change the order of this list.
            Add specific khels to this list from the "Browse All" section.
            Or surprise yourself and add randomly selected khels using "Generate more" button below.
            """)
            return cell
        case .khels:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: KhelCell.UseType.alreadyInList.rawValue, for: indexPath) as? KhelCell else { return UITableViewCell() }
            cell.update(list.list[indexPath.row], delegate: self)
            return cell
        case .generateMore:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ButtonCell.self), for: indexPath) as? ButtonCell else { return UITableViewCell() }
            cell.update("Generate more", systemImage: "plus.app.fill", bgColor: .systemBackground, font: .systemFont(ofSize: 17, weight: .bold), textColor: .label)
            return cell
        case .share:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ButtonCell.self), for: indexPath) as? ButtonCell else { return UITableViewCell() }
            cell.update("Share list", systemImage: "square.and.arrow.up", bgColor: .systemOrange, font: .systemFont(ofSize: 13, weight: .semibold), textColor: .white)
            return cell
        case .dangerZone:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ButtonCell.self), for: indexPath) as? ButtonCell else { return UITableViewCell() }
            cell.update("Delete entire list", systemImage: "trash", bgColor: .systemRed, font: .systemFont(ofSize: 13, weight: .semibold), textColor: .white)
            return cell
        case .none:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch Section(rawValue: indexPath.section) {
        case .khels:
            present(UINavigationController(rootViewController: KhelDetailVC(list.list[indexPath.row], useType: .alreadyInList)), animated: true)
        case .generateMore:
            let nav = UINavigationController(rootViewController: GenerateListVC(index, index: index))
            nav.presentationController?.delegate = self
            present(nav, animated: true)
        case .share:
            let items = ["\(list.name)\n\(list.enumeratedList)"]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(ac, animated: true)
        case .dangerZone:
            deleteEntireList()
        case .none, .info:
            return
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch Section(rawValue: indexPath.section) {
        case .dangerZone, .info, .share, .generateMore, .none:
            return false
        case .khels:
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let allLists = PlistManager.get(Lists.self, from: String(describing: Lists.self)) ?? Lists()
        let thisList = allLists.payload[self.index]
        let movedObject = thisList.list[sourceIndexPath.row]
        thisList.list.remove(at: sourceIndexPath.row)
        thisList.list.insert(movedObject, at: destinationIndexPath.row)
        list.list = thisList.list
        PlistManager.save(allLists, plistName: String(describing: Lists.self))
    }
    
}

extension ListDetailVC: KhelCellDelegate {
    
    func handleLeftButton(_ khel: Khel) {
        
        if list.list.count == 1 {
            deleteEntireList()
            return
        }
        
        let allLists = PlistManager.get(Lists.self, from: String(describing: Lists.self)) ?? Lists()
        let thisList = allLists.payload[self.index]
        thisList.list.removeAll(where: { $0 == khel })
        list.list = thisList.list
        PlistManager.save(allLists, plistName: String(describing: Lists.self))
        showRemovedSuccessAlert()
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .none)
    }
    
    private func showRemovedSuccessAlert() {
        let statusAlert = StatusAlert()
        statusAlert.image = UIImage(systemName: "trash")
        statusAlert.title = "Removed"
        statusAlert.appearance.tintColor = .label
        statusAlert.showInKeyWindow()
    }
    
    private func deleteEntireList() {
        let allLists = PlistManager.get(Lists.self, from: String(describing: Lists.self)) ?? Lists()
        allLists.payload.remove(at: index)
        PlistManager.save(allLists, plistName: String(describing: Lists.self))
        close()
        showRemovedSuccessAlert()
    }
    
}

extension ListDetailVC: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
}

extension ListDetailVC: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        guard let destinationSectionInt = destinationIndexPath?.section,
            Section.allCases[destinationSectionInt] == Section.khels,
            session.localDragSession != nil else {
                return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
        }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
    
}

extension ListDetailVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        let allLists = PlistManager.get(Lists.self, from: String(describing: Lists.self)) ?? Lists()
        list = allLists.payload[index]
        tableView.reloadData()
    }
}
