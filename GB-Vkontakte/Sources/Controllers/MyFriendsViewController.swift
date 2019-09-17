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
import FirebaseFirestore

class MyFriendsViewController: UITableViewController, UISearchBarDelegate {
    
    var friends = [RealmFriend]()
    
//    var friendsWithFullNames
    
    var friendsIndexArray: [Character] {
        return getFriendsIndexArray()
    }
    
    var friendsIndexDictionary: [Character: [RealmFriend]] {
        return getFriendsIndexDictionary()
    }
    
    var searchedFriends: [RealmFriend] = []
    
    var searchIsActive = false
    
    var photoService: PhotoService?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        
        searchBar.delegate = self
        
        self.photoService = PhotoService(container: self.tableView)
        
        VKService.loadFriendsData() {[weak self] in
            self?.loadFriendsData()
            self?.tableView?.reloadData()
        }
        
//        let db = Firestore.firestore()
//        let userId = (Auth.auth().currentUser?.uid)!
//
//        db.collection(userId).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }

//        var ref: DocumentReference? = nil
//        ref = db.collection(userId).document("favourite groups")
//        ref?.setData( [
//            "id111": "Куклы ручной работы",
//            "id222": "Counter-Strike not dead",
//            "id333": "Поездка в  Индию",
//            "id4444sds44": "MDK"
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
    }
    
    // MARK: - Functions
    
    func loadFriendsData() {
        do {
            let realm = try Realm()
            let friends = realm.objects(RealmFriend.self)
            self.friends = Array(friends)
            print(realm.configuration.fileURL)
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
        searchedFriends = self.friends.filter({(friend: RealmFriend) -> Bool in
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
            let rowsArray: [RealmFriend] = friendsIndexDictionary[char] ?? []
            return rowsArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.reuseIdentifier, for: indexPath) as? FriendCell else { return UITableViewCell() }
        
        if searchIsActive {
            let friend = searchedFriends[indexPath.row]
            cell.friendNameLabel.text = friend.fullName
            
            let avatarPath = searchedFriends[indexPath.row].photo
            if let url = URL(string: avatarPath) {
                let data = try? Data(contentsOf: url)
                if let imagedata = data {
                    cell.friendAvatar.image = UIImage(data: imagedata)
                }
            }
        } else {

            let char = friendsIndexArray[indexPath.section]
            
            let friend = friendsIndexDictionary[char]?[indexPath.row]

            cell.friendNameLabel.text = friend?.fullName
           
            if let url = friendsIndexDictionary[char]?[indexPath
                .row].photo {
                print(url)
                cell.friendAvatar.image = photoService?.photo(atIndexPath: indexPath, byUrl: url)
            }
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
    
    
    // функция для разлогинивания в fireBase
    @IBAction func logout(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Failed with error \(error)")
        }
    }
}


