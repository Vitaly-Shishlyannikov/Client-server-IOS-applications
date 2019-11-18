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

final class VKService {
        
    func loadUserGroupsData() {
        
        DispatchQueue.global(qos: .utility).async {
    
            Alamofire.request("https://api.vk.com/method/groups.get?extended=1&access_token=\(Session.instance.token)&v=5.95")
                .responseObject(completionHandler: { (vkResponse: DataResponse<VKGroupResponse>) in
                    
                    let groups = vkResponse.result.value?.response?.items ?? []
                    
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(groups, update: true)
                        }
    //                    print(realm.configuration.fileURL)
                    } catch {
                        print(error)
                    }
                })
        }
    }
    
    func loadAllGroupsData(textForGroupTitle: String) {
        
        DispatchQueue.global(qos: .utility).async {
        
            Alamofire.request("https://api.vk.com/method/groups.search?q=\(textForGroupTitle)&access_token=\(Session.instance.token)&v=5.95")
                .responseObject(completionHandler: { (vkResponse: DataResponse<VKCommonGroupResponse>) in
                    
                    let allGroups = vkResponse.result.value?.response?.items ?? []
                    
                    do {
                        let realm = try Realm()
                        let objects = realm.objects(RealmCommonGroup.self)
                        try realm.write {
                            realm.delete(objects)
                            realm.add(allGroups, update: true)
                        }
                        print(realm.configuration.fileURL as Any)
                    } catch {
                        print(error)
                    }
                })
        }
    }
    
    static func loadFriendsData(completion: @escaping ([Friend]) -> Void) {
        
        DispatchQueue.global(qos: .utility).async {
        
            Alamofire.request("https://api.vk.com/method/friends.get?fields=photo_50&access_token=\(Session.instance.token)&v=5.95")
                .responseObject(completionHandler: { (vkResponse: DataResponse<VKFriendResponse>) in
                    
                    let result = vkResponse.result
                    
                    let friends = result.value?.response?.items ?? []
                    
                    DispatchQueue.main.async {
                    completion(friends)
                    }
                })
        }
    }
    
    static func loadFriendsPhotos(friendID: String, completion: @escaping ([Photo]) -> Void) {
        
        DispatchQueue.global(qos: .utility).async {
        
            Alamofire.request("https://api.vk.com/method/photos.getAll?owner_id=\(friendID)&extended=1&access_token=\(Session.instance.token)&v=5.95")
                .responseObject(completionHandler: { (vkResponse: DataResponse<VKPhotoResponse>) in
                   
                    var photos: [Photo] = []
                    
                    let result = vkResponse.result
                    
                    let items = result.value?.response?.items ?? []
                    
                    for item in items {
                        if let photo = item.sizes.last {
                            photos.append(photo)
                            let likesCount = item.likes["count"]
                            photo.likesCount = likesCount ?? 0
                        }
                    }
                    
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_): completion(photos)
                        case .failure(let error): print(error)
                        }
                    }
                })
        }
    }
    
    func loadNews() {
        
        DispatchQueue.global(qos: .utility).async {
        
            Alamofire.request("https://api.vk.com/method/newsfeed.get?filters=post&access_token=\(Session.instance.token)&v=5.95")
                .responseObject(completionHandler: { (vkResponse: DataResponse<VKNewsResponse>) in
                
                let result = vkResponse.result
                
                let news = result.value?.response?.items ?? []
                    
                for item in 0..<news.count {
                    news[item].id = item
                }
                
                let sourceGroups = result.value?.response?.sourceGroups ?? []
                
                let sourceProfiles = result.value?.response?.sourceProfiles ?? []

                Realm.Configuration.defaultConfiguration = Realm.Configuration (deleteRealmIfMigrationNeeded: true)
                
                do {
                    
                    let realm = try Realm()
                    let objectsNews = realm.objects(NewsRaw.self)
                    let objectsGroups = realm.objects(SourceGroupRealm.self)
                    let objectsProfiles = realm.objects(SourceProfileRealm.self)
                    
                    try realm.write {
                        realm.delete(objectsNews)
                        realm.delete(objectsGroups)
                        realm.delete(objectsProfiles)
                        realm.add(sourceProfiles, update: true)
                        realm.add(sourceGroups, update: true)
                        realm.add(news, update: true)
                    }
                    print(realm.configuration.fileURL)
                } catch {
                    print(error)
                }
            })
        }
    }
}

