//
//  FriendsServerEmulator.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 31.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class FriendsServerEmulator {
    
    static var friends: [FriendModel] = [
        FriendModel(name: "Иванов Aндрей", avatarPath: "andrivanov"),
        FriendModel(name: "Петрова Елена", avatarPath: "elenapetrova"),
        FriendModel(name: "Дябина Наталья", avatarPath: "natadyabina"),
        FriendModel(name: "Пугачева Алла", avatarPath: "allapugacheva"),
        FriendModel(name: "Поляков Роман", avatarPath: "polyakovroman"),
        FriendModel(name: "Питт Бред", avatarPath: "bredpitt"),
        FriendModel(name: "Щукин Карась", avatarPath: "karas"),
        FriendModel(name: "Семенов Панкрат", avatarPath: "defaultAvatar"),
        FriendModel(name: "Иствуд Клинт", avatarPath: "clinteastwood"),
        FriendModel(name: "Завьялов Семен", avatarPath: "semenzavyalov"),
        FriendModel(name: "Сузуки Ямакаси", avatarPath: "defaultAvatar"),
        FriendModel(name: "Мамин Сибиряк", avatarPath: "mamin"),
        FriendModel(name: "Красоткина Прическа", avatarPath: "pricheska"),
        FriendModel(name: "Кроссовкин Дешеслав", avatarPath: "krossovki"),
        ]
    
    static func getFriends() -> [FriendModel]?{
        return friends
    }
    
    static func getOrderedFriendIndexArray() -> [Character]? {
        var friendIndexArray: [Character] = []
        for friend in friends {
            if let firstLetter = friend.name.first {
            friendIndexArray.append(firstLetter)
            }
        }
        friendIndexArray = Array(Set(friendIndexArray))
        friendIndexArray.sort()
        return friendIndexArray
    }
    
    static func getFriendIndexDictionary() -> [Character: [FriendModel]] {
        var friendIndexDictionary: [Character: [FriendModel]] = [:]
        
        for friend in friends {
            if let firstLetter = friend.name.first {
                if (friendIndexDictionary.keys.contains(firstLetter)) {
                    friendIndexDictionary[firstLetter]?.append(friend)
                } else {
                    friendIndexDictionary[firstLetter] = [friend]
                }
            }
        }
        return friendIndexDictionary
    }
}
