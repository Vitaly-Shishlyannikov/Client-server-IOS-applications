//
//  MyGroupsViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit
import RealmSwift

final class MyGroupsViewController: UITableViewController, UISearchBarDelegate {
    
    var groups = [RealmGroup]()
    
    var token: NotificationToken?
    
    var searchedGroups = [RealmGroup]()
    
    var searchIsActive = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        
        searchBar.delegate = self
        
        VKService.loadUserGroupsData(){[weak self] in
            self?.loadGroupsDataAndRealmNotifications()
            self?.tableView?.reloadData()
        }
    }
    
    // MARK: - Functions
    
    private func loadGroupsDataAndRealmNotifications() {
        guard let realm = try? Realm() else {return}
        let resultGroups = realm.objects(RealmGroup.self)
        token = resultGroups.observe({[weak self] changes in
            switch changes {
            case .initial(let results):
                self?.groups = Array(results)
            case let .update(results, deletions, insertions, modifications):
                self?.groups = Array(results)
                self?.tableView.performBatchUpdates({
                    self?.tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                    self?.tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                    self?.tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                })
            case .error(let error):
                print(error)
            }
        })
        self.groups = Array(resultGroups)
        
//        // проверка работы RealmNotifications, через 5 сек удаляется первая группа
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            try? realm.write {
//                realm.delete(self.groups.first!)
//            }
//        }
    }
    
    // MARK: - SearchBar delegate
    
    private func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchIsActive = true;
    }
    
    private func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchIsActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchIsActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchIsActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedGroups = self.groups.filter({(group: RealmGroup) -> Bool in
            return group.name.lowercased().contains(searchText.lowercased())
        })
        
        searchIsActive = searchText.count == 0 ? false : true
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchIsActive ? searchedGroups.count : groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.reuseIdentifier, for: indexPath) as? GroupCell else { return UITableViewCell() }
        
        let group = searchIsActive ? searchedGroups[indexPath.row] : groups[indexPath.row]
        
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

