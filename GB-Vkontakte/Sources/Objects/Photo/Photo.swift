//
//  Photo.swift
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

final class VKPhotoResponse: Mappable {
    var response: VKPhotoResponseInternal? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        response <- map["response"]
    }
}

final class VKPhotoResponseInternal: Mappable {
    var items: [Item]? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        items <- map["items"]
    }
}

final class Item: Mappable {
    var sizes: [Photo] = []
    var likes: [String: Int] = [:]
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        sizes <- map["sizes"]
        likes <- map["likes"]
    }
}

final class Likes: Mappable {
    
    var likesCount: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        likesCount <- map["count"]
    }
}

final class Photo: Mappable {
    
    var photoPath: String = ""
    var sizeType: String = ""
    var likesCount: Int = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        photoPath <- map["url"]
        sizeType <- map["type"]
    }
}
