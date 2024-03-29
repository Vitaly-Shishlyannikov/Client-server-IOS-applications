//
//  GroupAdapter.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 07.11.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import Foundation
import RealmSwift

final class GroupsAdapter {
    
    private let vkService = VKService()
    
    private var realmNotificationsToken = NotificationToken()
    
    func getGroups(completion: @escaping ([Group]) -> Void){
        
        guard let realm = try? Realm() else {return}
        let resultGroups = realm.objects(RealmGroup.self)
        
//        self.realmNotificationsToken.invalidate()
        
        let token = resultGroups.observe { [weak self] (changes: RealmCollectionChange) in
            
            guard let self = self else {return}
            switch changes {
            case .update(let realmGroups, _, insertions: _, modifications: _):
                var groups: [Group] = []
                for realmGroup in realmGroups {
                    groups.append(self.group(from: realmGroup))
                }
                self.realmNotificationsToken.invalidate()
                completion(groups)
            case .error(let error):
                fatalError("\(error)")
            case .initial:
                break
            }
        }
        self.realmNotificationsToken = token
        
        self.vkService.loadUserGroupsData()
    }

    private func group(from realmGroup: RealmGroup) -> Group {
        return Group(id: realmGroup.id,
                     photo: realmGroup.photo,
                     name: realmGroup.name)
    }
}

