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
import SafariServices

class AboutPageVC: UITableViewController {
    
    private let libraries = [(name: "JSSquircle", url: "https://github.com/janakmshah/JSSquircle", description: "A buttery smooth corner radius in iOS", author: "Janak Shah"),
                             (name: "LessAutolayoutBoilerplate", url: "https://github.com/janakmshah/LessAutolayoutBoilerplate", description: "A collection of useful UIView programmatic layout functions.", author: "Janak Shah"),
                             (name: "PlistManager", url: "https://github.com/janakmshah/PlistManager", description: "Lightweight plist data management framework, leveraging Codable in Swift", author: "Janak Shah"),
                             (name: "StatusAlert", url: "https://github.com/LowKostKustomz/StatusAlert", description: "Display Apple system-like self-hiding status alerts.", author: "Yehor Miroshnychenko")]
    
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
        tableView.register(LibraryCell.self, forCellReuseIdentifier: String(describing: LibraryCell.self))
        tableView.register(ButtonCell.self, forCellReuseIdentifier: String(describing: ButtonCell.self))
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
            label.text = "Libraries used:"
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
        case .contactSupport: return 16
        case .openSource: return 16
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
            cell.updateText("""
            This app is based on the awesome work done by Mitesh Sevani to digitise the big book of Khel.

            Feedback, suggestions and questions on anything about this app is welcome, you can contact the developers using the button below.

            The project is 100% open source and can be found on Github using the button below. Pull requests for improvements and extended functionality are welcome.
            """)
            return cell
        case .libraries:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LibraryCell.self), for: indexPath) as? LibraryCell else { return UITableViewCell() }
            let library = libraries[indexPath.row]
            cell.update(library.name, author: library.author, description: library.description)
            return cell
        case .contactSupport:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ButtonCell.self), for: indexPath) as? ButtonCell else { return UITableViewCell() }
            cell.update("Contact developers", systemImage: "envelope", bgColor: .systemBlue, font: .systemFont(ofSize: 13, weight: .semibold), textColor: .white)
            return cell
        case .openSource:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ButtonCell.self), for: indexPath) as? ButtonCell else { return UITableViewCell() }
            cell.update("Github repo", systemImage: "folder", bgColor: .systemBlue, font: .systemFont(ofSize: 13, weight: .semibold), textColor: .white)
            return cell
        case .none:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch Section(rawValue: indexPath.section) {
        case .libraries:
            if let url = URL(string: libraries[indexPath.row].url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .contactSupport:
            if let url = URL(string: "https://appktchn.com/contact-us/") {
                let config = SFSafariViewController.Configuration()
                let vc = SFSafariViewController(url: url, configuration: config)
                present(vc, animated: true)
            }
        case .openSource:
            if let url = URL(string: "https://github.com/janakmshah/Khel-iOS") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .none, .info:
            return
        }
        
    }
    
}
