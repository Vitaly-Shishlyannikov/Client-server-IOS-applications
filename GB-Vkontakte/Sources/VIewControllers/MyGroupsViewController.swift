//
//  MyGroupsViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

final class MyGroupsViewController: UITableViewController, UISearchBarDelegate {
    
    var groups = [Group]()
    
    var searchedGroups = [Group]()
    
    var searchIsActive = false
    
    var groupService = GroupsAdapter()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        
        searchBar.delegate = self
        
        groupService.getGroups { [weak self] groups in
            self?.groups = groups
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - SearchBar delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchIsActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchIsActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchIsActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchIsActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedGroups = self.groups.filter({(group: Group) -> Bool in
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
        }
            
            let newIndexPath = IndexPath(item: groups.count - 1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}

