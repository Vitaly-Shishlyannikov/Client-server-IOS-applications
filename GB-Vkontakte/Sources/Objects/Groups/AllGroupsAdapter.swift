//
//  AllGroupsAdapter.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 07.11.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import Foundation
import RealmSwift

final class AllGroupsAdapter {
    
    private let vkService = VKService()
    
    private var realmNotificationsToken = NotificationToken()
    
    func getAllGroups(textForGroupTitle: String, completion: @escaping ([Group]) -> Void){
        
        self.vkService.loadAllGroupsData(textForGroupTitle: textForGroupTitle)
        
        guard let realm = try? Realm() else {return}
        let resultGroups = realm.objects(RealmCommonGroup.self)
        
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
    }
    
    private func group(from realmCommonGroup: RealmCommonGroup) -> Group {
        return Group(id: realmCommonGroup.id,
                     photo: realmCommonGroup.photo,
                     name: realmCommonGroup.name)
    }
}
