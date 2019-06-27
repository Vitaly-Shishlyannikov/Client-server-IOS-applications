//
//  AllGroupsViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class MyFriendsViewController: UITableViewController {
    
    var friends: [FriendModel] = []
    var friendsIndex: [Character] = []
    var friendsIndexDictionary: [Character: [FriendModel]] = [:]
    var searchedFriends: [FriendModel] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriends()
        getFriendsIndexArray()
        getFriendsIndexDictionary()
        self.tableView.rowHeight = 70
        
        searchedFriends = friends
    }
    
    // MARK: - Get data
    
    func getFriends () {
        friends = FriendsServerEmulator.getFriends() ?? []
    }
    
    func getFriendsIndexArray () {
        friendsIndex = FriendsServerEmulator.getOrderedFriendIndexArray() ?? []
    }
    
    func getFriendsIndexDictionary () {
        friendsIndexDictionary = FriendsServerEmulator.getFriendIndexDictionary()
    }
    
    
    
    // MARK: - Table view data source
    
    // количество секций равно количеству элементов в массиве первых букв
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsIndex.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // для каждой буквы в массиве индексов проверяем соответствие первой букве фамилии
        // всех друзей, добавляем при совпадении и возвращаем кол-во элементов для секции
        let char = friendsIndex[section]
        let rowsArray: [FriendModel] = friendsIndexDictionary[char] ?? []
        return rowsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let char = friendsIndex[indexPath.section]
        let friendName = friendsIndexDictionary[char]?[indexPath.row].name
        let avatarPath = friendsIndexDictionary[char]?[indexPath.row].avatarPath
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.reuseIdentifier, for: indexPath) as? FriendCell else { return UITableViewCell() }
        cell.friendNameLabel.text = friendName
        cell.friendAvatar.image = UIImage(named: avatarPath!)
        //cell.contentView.backgroundColor = UIColor.white
        
        return cell
    }
    
    // метод контрола для быстрого перехода по первым буквам фамилий
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // преобразуем массив [Chararacter] в [String]
        let friendsIndexString = friendsIndex.map {String($0)}
        return friendsIndexString
    }
    
    // текст для header секции, берется из массива индексов
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(friendsIndex[section])
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
        if segue.identifier == "PhotoSegue",
            let photoController = segue.destination as? PhotoCollectionViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            let selectedFriendCharacter = friendsIndex[indexPath.section]
            print(indexPath)
            print(friendsIndexDictionary)
            let photoName = friendsIndexDictionary[selectedFriendCharacter]?[indexPath.row].name
            photoController.friendNameForTitle = photoName ?? ""
            }
    }
}

//extension MyFriendsViewController: UITableViewDelegate, UITableViewDataSource {
//    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//    }
//}

