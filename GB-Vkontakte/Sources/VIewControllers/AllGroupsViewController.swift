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
    
    var searchText = String() {
        willSet {
                groupService.getAllGroups(textForGroupTitle: newValue) {[weak self] groups in
                self?.groups = groups
                self?.tableView.reloadData()
            }
        }
    }
    
    var searchIsActive = false
    
    var groupService = AllGroupsAdapter()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        
        searchBar.delegate = self
        
        groupService.getAllGroups(textForGroupTitle: searchText) {[weak self] groups in
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
        
        self.searchText = searchText

//        searchedGroups = self.groups.filter({(group: Group) -> Bool in
//            return group.name.lowercased().contains(searchText.lowercased())
//        })

        searchIsActive = searchText.count == 0 ? false : true
        
        tableView.reloadData()
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
