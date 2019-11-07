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
    
    func loadAllGroupsData() {
        
        DispatchQueue.global(qos: .utility).async {
        
            Alamofire.request("https://api.vk.com/method/groups.search?q=c&access_token=\(Session.instance.token)&v=5.95")
                .responseObject(completionHandler: { (vkResponse: DataResponse<VKCommonGroupResponse>) in
                    
                    let allGroups = vkResponse.result.value?.response?.items ?? []
                    
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(allGroups, update: true)
                        }
//                        print(realm.configuration.fileURL)
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
                    
                    for friend in friends {
                        friend.fullName = friend.firstName + " " + friend.lastName
                    }
                    
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
    
    static func loadNews(completion: @escaping ([News]) -> Void) {
        
        debugPrint("isMainThread \(Thread.isMainThread)")
        
        DispatchQueue.global(qos: .utility).async {
        
            Alamofire.request("https://api.vk.com/method/newsfeed.get?filters=post&access_token=\(Session.instance.token)&v=5.95")
                .responseObject(completionHandler: { (vkResponse: DataResponse<VKNewsResponse>) in
                
                let result = vkResponse.result
                
                let news = result.value?.response?.items ?? []
                
                let sourceGroups = result.value?.response?.sourceGroups ?? []
                
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(sourceGroups, update: true)
                    }
//                    print(realm.configuration.fileURL)
                } catch {
                    print(error)
                }
                
                let sourceProfiles = result.value?.response?.sourceProfiles ?? []
                
                for sourceProfile in sourceProfiles {
                    sourceProfile.fullName = sourceProfile.firstName + " " + sourceProfile.lastName
                }
                
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(sourceProfiles, update: true)
                    }
//                    print(realm.configuration.fileURL)
                } catch {
                    print(error)
                }
                    DispatchQueue.main.async {
                        completion(news)
                    }
            })
        }
    }
    
    static func getGroupSourceOfNewsFromRealm(sourceId: Int) -> SourceGroupRealm? {
        
        let sourceOfNews = try? Realm()
        let source = sourceOfNews?.objects(SourceGroupRealm.self).filter("id == %@", -sourceId).first
        return source
    }
    
    static func getProfileSourceOfNewsFromRealm(sourceId: Int) -> SourceProfileRealm? {
        
        let sourceOfNews = try? Realm()
        let source = sourceOfNews?.objects(SourceProfileRealm.self).filter("id == %@", sourceId).first
        return source
    }
}

