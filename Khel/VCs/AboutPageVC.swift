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

class AboutPageVC: UITableViewController {
    
    private let libraries = [(name: "Name", url: "url", author: "author")]
    
    enum Section: Int, CaseIterable {
        case info
        case contactSupport
        case openSource
        case libraries
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(ListInfoCell.self, forCellReuseIdentifier: String(describing: ListInfoCell.self))
        tableView.register(KhelCell.self, forCellReuseIdentifier: KhelCell.UseType.alreadyInList.rawValue)
        tableView.register(DeleteCell.self, forCellReuseIdentifier: String(describing: DeleteCell.self))
        tableView.register(ShareCell.self, forCellReuseIdentifier: String(describing: ShareCell.self))
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        tableView.backgroundColor = .secondarySystemBackground
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if Section.allCases[section] == .libraries {
            let view = UIView()
            view.backgroundColor = .secondarySystemBackground
            
            let label = UILabel()
            label.text = "Danger zone!"
            label.font = .systemFont(ofSize: 13, weight: .semibold)
            label.textColor = .secondaryLabel
            
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
        case .libraries: return 8
        case .contactSupport: return 0
        case .openSource: return 0
        case .none: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Section(rawValue: section) {
        case .info: return 0
        case .contactSupport: return 8
        case .openSource: return 0
        case .libraries: return 26
        case .none: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch Section(rawValue: section) {
        case .info: return 1
        case .contactSupport: return 1
        case .openSource: return 1
        case .libraries: return libraries.count
        case .none: return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch Section(rawValue: indexPath.section) {
        case .info:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListInfoCell.self), for: indexPath) as? ListInfoCell else { return UITableViewCell() }
            return cell
        case .libraries:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: KhelCell.UseType.alreadyInList.rawValue, for: indexPath) as? KhelCell else { return UITableViewCell() }
            //cell.update(list.list[indexPath.row], delegate: self)
            return cell
        case .contactSupport:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShareCell.self), for: indexPath) as? ShareCell else { return UITableViewCell() }
            return cell
        case .openSource:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DeleteCell.self), for: indexPath) as? DeleteCell else { return UITableViewCell() }
            return cell
        case .none:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch Section(rawValue: indexPath.section) {
        case .libraries:
            break
        case .contactSupport:
            break
        case .openSource:
            break
        case .none, .info:
            return
        }
        
    }
    
}
