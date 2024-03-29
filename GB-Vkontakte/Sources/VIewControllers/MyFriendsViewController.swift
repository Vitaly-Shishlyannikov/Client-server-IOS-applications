//
//  AllGroupsViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

final class MyFriendsViewController: UITableViewController, UISearchBarDelegate {
    
    var friends = [Friend]()
    
    var friendsIndexArray = [Character]()
    
    var friendsIndexDictionary = [Character: [FriendViewModel]]()
    
    var searchedFriends: [FriendViewModel] = []
    
    var searchIsActive = false
    
    var photoService: PhotoService?
    
    private let friendViewModelFactory = FriendViewModelFactory()
    
    private var friendViewModels: [FriendViewModel] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        
        searchBar.delegate = self
        
        self.photoService = PhotoService(container: self.tableView)
        
        VKService.loadFriendsData() {[weak self] friendsArray in
            
            guard let self = self else {return}
            
            self.friends = friendsArray
            
            self.friendViewModels = self.friendViewModelFactory.constructViewModels(from: self.friends)
            
            self.getFriendsIndexArray(friendsArray: self.friendViewModels) {[weak self] indexArray in
                self?.friendsIndexArray = indexArray
            }

            self.getFriendsIndexDictionary(friendsArray: self.friendViewModels) {[weak self] dictionary in
                self?.friendsIndexDictionary = dictionary
            }
            
            self.tableView?.reloadData()
            }
    }
    
    // MARK: - Functions
    
    private func getFriendsIndexArray(friendsArray: [FriendViewModel], completion: @escaping ([Character]) -> Void) {
            
        var friendIndexArray: [Character] = []
        for friend in friendsArray {
            if let firstLetter = friend.lastName.first {
                friendIndexArray.append(firstLetter)
                print(firstLetter)
            }
        }
        friendIndexArray = Array(Set(friendIndexArray))
        friendIndexArray.sort()
        
        completion(friendIndexArray)
        print(friendIndexArray)
    }
    
    private func getFriendsIndexDictionary(friendsArray: [FriendViewModel], completion: @escaping ([Character:[FriendViewModel]]) -> Void) {
        
        var frIndDict: [Character: [FriendViewModel]] = [:]
        for friend in friendsArray {
            if let firstLetter = friend.lastName.first {
                if (frIndDict.keys.contains(firstLetter)) {
                    frIndDict[firstLetter]?.append(friend)
                } else {
                    frIndDict[firstLetter] = [friend]
                }
            }
        }
        print(frIndDict)
        completion(frIndDict)
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
        searchedFriends = self.friendViewModels.filter({(friend: FriendViewModel) -> Bool in
            return friend.firstName.lowercased().contains(searchText.lowercased()) ||
            friend.lastName.lowercased().contains(searchText.lowercased())
        })
        
        searchIsActive = searchText.count == 0 ? false : true
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    // количество секций равно количеству элементов в массиве первых букв
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return searchIsActive ? 1 : friendsIndexArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // для каждой буквы в массиве индексов проверяем соответствие первой букве фамилии
        // всех друзей, добавляем при совпадении и возвращаем кол-во элементов для секции
        
        if searchIsActive {
            return searchedFriends.count
        } else {
            let char = friendsIndexArray[section]
            let rowsArray: [FriendViewModel] = friendsIndexDictionary[char] ?? []
            return rowsArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.reuseIdentifier, for: indexPath) as? FriendCell else { return UITableViewCell() }
        
        if searchIsActive {
            
            cell.configure(with: friendViewModels[indexPath.row])
        
        } else {
            
            let char = friendsIndexArray[indexPath.section]
            let friend = friendsIndexDictionary[char]?[indexPath.row]
            
            cell.configure(with: friend!)
        }
        
        return cell
    }
    
    // метод контрола для быстрого перехода по первым буквам фамилий
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // преобразуем массив [Chararacter] в [String]
        let friendsIndexString = friendsIndexArray.map {String($0)}
        return searchIsActive ? nil : friendsIndexString
    }
    
    // текст для header секции, берется из массива индексов
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchIsActive ? nil : String(friendsIndexArray[section])
    }
    
    // header секции и настройка его цвета
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        if let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
            header.backgroundView?.alpha = 0.5
            header.backgroundView?.backgroundColor = UIColor.white
        }
    }
    
    // функция удаления друзей
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "PhotoSegue",
            let photoController = segue.destination as? PhotoCollectionViewController,
            let indexPath = tableView.indexPathForSelectedRow {
                let selectedFriendCharacter = friendsIndexArray[indexPath.section]
                let friend = friendsIndexDictionary[selectedFriendCharacter]?[indexPath.row]
            photoController.friendNameForTitle = friend?.fullName ?? ""
            
                let selectedFriendID = friendsIndexDictionary[selectedFriendCharacter]?[indexPath.row].id
                photoController.selectedFriendID = String(selectedFriendID ?? 1)
            }
    }
}


