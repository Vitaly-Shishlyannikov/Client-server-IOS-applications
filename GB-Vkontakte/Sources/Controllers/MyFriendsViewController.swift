//
//  AllGroupsViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class MyFriendsViewController: UITableViewController {
    
    var friends = [RealmFriend]()
    
    var friendsIndexArray: [Character] {
        return getFriendsIndexArray()
    }
    
    var friendsIndexDictionary: [Character: [RealmFriend]] {
        return getFriendsIndexDictionary()
    }
    
    var searchedFriends: [RealmFriend] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        
        VKService.loadFriendsData() {[weak self] in
            self?.loadFriendsData()
            self?.tableView?.reloadData()
        }
    }
    
    // MARK: - Functions
    
    func loadFriendsData() {
        do {
            let realm = try Realm()
            let friends = realm.objects(RealmFriend.self)
            self.friends = Array(friends)
        } catch {
            print(error)
        }
    }
    
    func getFriendsIndexArray() -> [Character] {
        
        var friendIndexArray: [Character] = []
        for friend in friends {
            if let firstLetter = friend.lastName.first {
                friendIndexArray.append(firstLetter)
            }
        }
        friendIndexArray = Array(Set(friendIndexArray))
        friendIndexArray.sort()
        return friendIndexArray
    }
    
    func getFriendsIndexDictionary() -> [Character: [RealmFriend]] {
        
        var frIndDict: [Character: [RealmFriend]] = [:]
        for friend in friends {
            if let firstLetter = friend.lastName.first {
                if (frIndDict.keys.contains(firstLetter)) {
                    frIndDict[firstLetter]?.append(friend)
                } else {
                    frIndDict[firstLetter] = [friend]
                }
            }
        }
        return frIndDict
    }
    
    // MARK: - Table view data source
    
    // количество секций равно количеству элементов в массиве первых букв
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsIndexArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // для каждой буквы в массиве индексов проверяем соответствие первой букве фамилии
        // всех друзей, добавляем при совпадении и возвращаем кол-во элементов для секции
        let char = friendsIndexArray[section]
        let rowsArray: [RealmFriend] = friendsIndexDictionary[char] ?? []
        return rowsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.reuseIdentifier, for: indexPath) as? FriendCell else { return UITableViewCell() }

        let char = friendsIndexArray[indexPath.section]
        guard let friendFirstName = friendsIndexDictionary[char]?[indexPath.row].firstName else {return UITableViewCell()}
        guard let friendLastName = friendsIndexDictionary[char]?[indexPath.row].lastName else {return UITableViewCell()}
        let friendFullName = friendFirstName + " " + friendLastName
        
        cell.friendNameLabel.text = friendFullName
        
        guard let avatarPath = friendsIndexDictionary[char]?[indexPath
            .row].photo else {return UITableViewCell()}
        guard let url = URL(string: avatarPath) else {return UITableViewCell()}
        let data = try? Data(contentsOf: url)
        if let imagedata = data {
            cell.friendAvatar.image = UIImage(data: imagedata)
        //cell.contentView.backgroundColor = UIColor.white
        }
        return cell
    }
    
    // метод контрола для быстрого перехода по первым буквам фамилий
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // преобразуем массив [Chararacter] в [String]
        let friendsIndexString = friendsIndexArray.map {String($0)}
        return friendsIndexString
    }
    
    // текст для header секции, берется из массива индексов
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(friendsIndexArray[section])
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
                let selectedFriendCharacter = friendsIndexArray[indexPath.section]
            guard let firstName = friendsIndexDictionary[selectedFriendCharacter]?[indexPath.row].firstName else {return}
            guard let lastName = friendsIndexDictionary[selectedFriendCharacter]?[indexPath.row].lastName else {return}
            let photoName = firstName + " " + lastName
            photoController.friendNameForTitle = photoName
            
            let selectedFriendID = friendsIndexDictionary[selectedFriendCharacter]?[indexPath.row].id
            photoController.selectedFriendID = String(selectedFriendID ?? 1)
            }
    }
    @IBAction func logout(_ sender: Any) {
//        try? Auth.auth().signOut()
//        navigationController?.popViewController(animated: true)
        
        do{
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Failed with error \(error)")
        }
    }
}


