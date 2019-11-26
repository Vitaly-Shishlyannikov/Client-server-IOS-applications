//
//  VKServiceProxy.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 26/11/2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import Foundation

final class VKServiceProxy: VKServiceInterface {
    let vkService: VKService
    init(vkService: VKService) {
        self.vkService = vkService
    }
    
    func loadFriendsData(completion: @escaping ([Friend]) -> Void) {
        self.vkService.loadFriendsData(completion: completion)
        print("Данные о списке друзей были запрошены")
    }
    
    func loadFriendsPhotos(friendID: String, completion: @escaping ([Photo]) -> Void) {
        self.vkService.loadFriendsPhotos(friendID: friendID, completion: completion)
        print("Данные о фото друзей были запрошены")
    }
    
    func loadUserGroupsData() {
        self.vkService.loadUserGroupsData()
        print("Данные о группах юзера были запрошены")
    }
    
    func loadAllGroupsData(textForGroupTitle: String) {
        self.vkService.loadAllGroupsData(textForGroupTitle: textForGroupTitle)
        print("Данные о найденных группах по запросу друзей были запрошены")
    }
    
    func loadNews() {
        self.vkService.loadNews()
        print("Данные о новостях были запрошены")
    }
}
