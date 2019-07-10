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

class VKService {
        
    static func loadUserGroupsData(completion: @escaping ([Group]) -> Void) {
    
        Alamofire.request("https://api.vk.com/method/groups.get?extended=1&access_token=\(Session.instance.token)&v=5.95")
            .responseObject(completionHandler: { (vkResponse: DataResponse<VKGroupResponse>) in
                let result = vkResponse.result
                switch result {
                case .success(let val): print(val.response?.items)
                case .failure(let error): print(error)
                }
                let resultValue = result.value?.response?.items
                completion(resultValue!)
            })
        }
    
    static func loadAllGroupsData(completion: @escaping ([Group]) -> Void) {
        
        Alamofire.request("https://api.vk.com/method/groups.search?q=a&access_token=\(Session.instance.token)&v=5.95")
            .responseObject(completionHandler: { (vkResponse: DataResponse<VKGroupResponse>) in
                let result = vkResponse.result
                switch result {
                case .success(let val): print(val.response?.items)
                case .failure(let error): print(error)
                }
                let resultValue = result.value?.response?.items
                completion(resultValue!)
            })
    }
    
    static func loadFriendsData(completion: @escaping ([Friend]) -> Void) {
        
        Alamofire.request("https://api.vk.com/method/friends.get?fields=photo_50&access_token=\(Session.instance.token)&v=5.95")
            .responseObject(completionHandler: { (vkResponse: DataResponse<VKFriendResponse>) in
                let result = vkResponse.result
                switch result {
                case .success(let val): print(val.response?.items)
                case .failure(let error): print(error)
                }
                let resultValue = result.value?.response?.items
                completion(resultValue!)
            })
    }
}

