//
//  Friend.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 08.07.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class VKFriendResponse: Mappable {
    var response: VKFriendResponseInternal? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        response <- map["response"]
    }
}

class VKFriendResponseInternal: Mappable {
    var items: [Friend] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        items <- map["items"]
    }
}

class Friend: Mappable {
    
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var fullName: String = ""
    var photo: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        photo <- map["photo_50"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        fullName <- map["track_code"]
    }
}
