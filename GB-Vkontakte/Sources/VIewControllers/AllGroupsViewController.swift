//
//  AllGroupsViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

final class AllGroupsViewController: UITableViewController, UISearchBarDelegate {
    
    var groups = [Group]()
    
    var searchedGroups = [Group]()
    
    var searchIsActive = false
    
    var groupService = AllGroupsAdapter()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        
        searchBar.delegate = self
        
        groupService.getAllGroups {[weak self] groups in
            self?.groups = groups
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - SearchBar delegate
    
    private func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchIsActive = true;
    }
    
    private func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchIsActive = false;
    }
    
    private func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchIsActive = false;
    }
    
    private func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchIsActive = false;
    }
    
    private func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
}
