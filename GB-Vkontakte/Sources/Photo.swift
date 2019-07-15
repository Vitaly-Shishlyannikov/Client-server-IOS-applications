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

class VKPhotoResponse: Mappable {
    var response: VKPhotoResponseInternal? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        response <- map["response"]
    }
}

class VKPhotoResponseInternal: Mappable {
    var items: [VKPhotoResponseInInternal]? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        items <- map["items"]
    }
}

class VKPhotoResponseInInternal: Mappable {
    var sizes: [Photo] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        sizes <- map["sizes"]
    }
}

class Photo: Mappable {
    
    var photoPath: String = ""
    var sizeType: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        photoPath <- map["url"]
        sizeType <- map["type"]
    }
}
