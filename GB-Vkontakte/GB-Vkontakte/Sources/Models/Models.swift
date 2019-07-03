//
//  Models.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

struct GroupModel {
    
    var name: String
    var avatarPath: String
    
}

struct FriendModel {
    
    var name: String
    var avatarPath: String
    
}

struct PhotoModel {
    var photoPath: String
}

struct NewsModel {
    let newsId: String
    let newsSource: String
    let newsSourceImage: String
    let newsText: String
    let newsPicturePath: String
    let likesCount: Int
    let commentsCount: Int
    let sharesCount: Int
    let viewsCount: Int
}
