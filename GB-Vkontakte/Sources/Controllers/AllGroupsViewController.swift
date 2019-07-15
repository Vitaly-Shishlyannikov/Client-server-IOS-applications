//
//  AllGroupsViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class AllGroupsViewController: UITableViewController {
    
//    var groups: [GroupModel] = [
//        GroupModel(name: "Марсиане среди нас", avatarPath: "marsiane"),
//        GroupModel(name: "Любители психостимуляторов", avatarPath: "psicho"),
//        GroupModel(name: "Теории заговоров 18 века", avatarPath: "zagovor"),
//        GroupModel(name: "Группа для тех, у кого живет домовой", avatarPath: "domovoi"),
//        GroupModel(name: "Разработка IOS", avatarPath: "ios"),
//    ]
    
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 70
        
        VKService.loadAllGroupsData(){[weak self] groups in
            self?.groups = groups
            self?.tableView?.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.reuseIdentifier, for: indexPath) as? GroupCell else { return UITableViewCell() }
        let group = groups[indexPath.row]
        cell.groupNameLabel.text = group.name
        
        let url = URL(string: group.photo)
        let data = try? Data(contentsOf: url!)
        if let imagedata = data {
            cell.groupAvatar.image = UIImage(data: imagedata)
        }
        return cell
    }
}
