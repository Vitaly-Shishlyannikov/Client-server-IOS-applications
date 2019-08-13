//
// Post.swift
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

class VKPostResponse: Mappable {
    var response: VKPostItems? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        response <- map["response"]
    }
}

class VKPostItems: Mappable {
    var items: [Post] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        items <- map["items"]
    }
}

//class VKPostAttachments: Mappable {
//    var attachments: [VKPostPhotos?] = []
//
//    required init?(map: Map) {}
//
//    func mapping(map: Map) {
//       attachments <- map["attachments"]
//    }
//}
//
//class VKPostPhotos: Mappable {
//    var photo: VKPostPhotoSizes? = nil
//
//    required init?(map: Map) {}
//
//    func mapping(map: Map) {
//        photo <- map["photo"]
//    }
//}
//
//class VKPostPhotoSizes: Mappable {
//    var sizes: [Post] = []
//
//    required init?(map: Map) {}
//
//    func mapping(map: Map) {
//        sizes <- map["sizes"]
//    }
//}

class Post: Mappable {
    
    @objc dynamic var source_id: Int = 0
    @objc dynamic var text: String = ""
    @objc dynamic var photoURL: String = ""
    @objc dynamic var comments: Int = 0
    @objc dynamic var likes: Int = 0
    @objc dynamic var reposts: Int = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        source_id <- map["source_id"]
        text <- map["text"]
        photoURL <- map["url"]
        comments <- map["comments"]
        likes <- map["likes"]
        reposts <- map["reposts"]
    }
}
