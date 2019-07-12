//
//  Group.swift
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

class VKGroupResponse: Mappable {
    var response: VKGroupResponseInternal? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        response <- map["response"]
    }
}

class VKGroupResponseInternal: Mappable {
    var items: [Group] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        items <- map["items"]
    }
}

class Group: Mappable {
    var id: Int = 0
    var photo: String = ""
    var name: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        photo <- map["photo_50"]
        name <- map["name"]
    }
}

