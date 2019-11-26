//
//  VKServiceInterface.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 26/11/2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import Foundation

protocol VKServiceInterface {
    func loadFriendsData(completion: @escaping ([Friend]) -> Void)
    func loadFriendsPhotos(friendID: String, completion: @escaping ([Photo]) -> Void)
    func loadUserGroupsData()
    func loadAllGroupsData(textForGroupTitle: String)
    func loadNews()
}
