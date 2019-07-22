//
//  MyGroupsViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsViewController: UITableViewController {
    
    var groups = [RealmGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        
        VKService.loadUserGroupsData(){[weak self] in
            self?.loadGroupsData()
            self?.tableView?.reloadData()
        }
    }
    
    // MARK: - Functions
    
    func loadGroupsData() {
        do {
            let realm = try Realm()
            let groups = realm.objects(RealmGroup.self)
            self.groups = Array(groups)
        } catch {
            print(error)
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
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if let controller = segue.source as? AllGroupsViewController,
        let indexPath = controller.tableView.indexPathForSelectedRow {
            let group = controller.groups[indexPath.row]

            guard !groups.contains(where: { $0.name == group.name }) else { return }

            groups.append(group)
            let newIndexPath = IndexPath(item: groups.count - 1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}
