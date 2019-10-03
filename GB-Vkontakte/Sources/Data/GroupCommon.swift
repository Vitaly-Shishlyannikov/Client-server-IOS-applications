//
//  GroupPublic.swift
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

final class VKCommonGroupResponse: Mappable {
    var response: VKCommonGroupResponseInternal? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        response <- map["response"]
    }
}

final class VKCommonGroupResponseInternal: Mappable {
    var items: [RealmCommonGroup] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        items <- map["items"]
    }
}

final class RealmCommonGroup: RealmGroup {
}

