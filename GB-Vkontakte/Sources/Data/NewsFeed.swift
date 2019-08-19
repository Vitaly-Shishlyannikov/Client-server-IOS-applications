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
import RealmSwift

class VKNewsResponse: Mappable {
    var response: VKNewsItems? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        response <- map["response"]
    }
}

class VKNewsItems: Mappable {
    var items: [News] = []
    var sourceProfiles: [SourceProfileRealm] = []
    var sourceGroups: [SourceGroupRealm] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        items <- map["items"]
        sourceGroups <- map["groups"]
        sourceProfiles <- map["profiles"]
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

class SourceProfileRealm: Object, Mappable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var fullName: String = ""
    @objc dynamic var photoURL: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        photoURL <- map["photo_50"]
    }
}

class SourceGroupRealm: Object, Mappable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photoURL: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        photoURL <- map["photo_50"]
    }
}

class News: Mappable {
    
    @objc dynamic var source_id: Int = 0
    @objc dynamic var text: String = ""
    @objc dynamic var photoURL: String = ""
    @objc dynamic var comments: Int = 0
    @objc dynamic var likes: Int = 0
    @objc dynamic var reposts: Int = 0
    
    @objc dynamic var photoNews: String = ""
    
    @objc dynamic var sourceGroupName: String = ""
    @objc dynamic var sourceGroupPhotoURL: String = ""
    
    @objc dynamic var sourceProfileName: String = ""
    @objc dynamic var sourceProfilePhotoURL: String = ""
    
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        source_id <- map["source_id"]
        text <- map["text"]
        photoURL <- map["url"]
        comments <- map["comments.count"]
        likes <- map["likes.count"]
        reposts <- map["reposts.count"]
        
        photoNews <- map ["attachments.photo.sizes.5.url"]
    }
}
