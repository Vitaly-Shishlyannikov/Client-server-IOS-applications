//
//  VKService.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 07.07.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift

class VKService {
        
    static func loadUserGroupsData(completion: @escaping () -> Void) {
    
        Alamofire.request("https://api.vk.com/method/groups.get?extended=1&access_token=\(Session.instance.token)&v=5.95")
            .responseObject(completionHandler: { (vkResponse: DataResponse<VKGroupResponse>) in
                
                guard let groups = vkResponse.result.value?.response?.items else {return}
                
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(groups, update: true)
                    }
//                    print(realm.configuration.fileURL)
                } catch {
                    print(error)
                }
                completion()
            })
        }
    
    static func loadAllGroupsData(completion: @escaping () -> Void) {
        
        Alamofire.request("https://api.vk.com/method/groups.search?q=c&access_token=\(Session.instance.token)&v=5.95")
            .responseObject(completionHandler: { (vkResponse: DataResponse<VKGroupResponse>) in
                guard let groups = vkResponse.result.value?.response?.items else {return}
                
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(groups, update: true)
                    }
//                    print(realm.configuration.fileURL)
                } catch {
                    print(error)
                }
                completion()
            })
    }
    
    static func loadFriendsData(completion: @escaping () -> Void) {
        
        Alamofire.request("https://api.vk.com/method/friends.get?fields=photo_50&access_token=\(Session.instance.token)&v=5.95")
            .responseObject(completionHandler: { (vkResponse: DataResponse<VKFriendResponse>) in
                let result = vkResponse.result
                guard let friends = result.value?.response?.items else {return}
                
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(friends, update: true)
                    }
//                    print(realm.configuration.fileURL)
                } catch {
                    print(error)
                }
                completion()
            })
    }
    
    static func loadFriendsPhotos(friendID: String, completion: @escaping ([Photo]) -> Void) {
        
        Alamofire.request("https://api.vk.com/method/photos.getAll?owner_id=\(friendID)&extended=1&access_token=\(Session.instance.token)&v=5.95")
            .responseObject(completionHandler: { (vkResponse: DataResponse<VKPhotoResponse>) in
               
                var photos: [Photo] = []
                let result = vkResponse.result
                let items = result.value?.response?.items ?? []
                
                for item in items {
                    guard let photo = item.sizes.first else {return}
                    photos.append(photo)
                }
                
                switch result {
                case .success(_): completion(photos)
                case .failure(let error): print(error)
                }
            })
    }
    
    static func loadNews(completion: @escaping ([Post]) -> Void) {
        
        Alamofire.request("https://api.vk.com/method/newsfeed.get?filters=post&access_token=\(Session.instance.token)&v=5.95")
            .responseObject(completionHandler: { (vkResponse: DataResponse<VKPostResponse>) in
                
                let result = vkResponse.result
                
                guard let news = result.value?.response?.items else {return}
                
                switch result {
                case .success(_): completion(news)
                case .failure(let error): print(error)
                }
            })
    }
}

