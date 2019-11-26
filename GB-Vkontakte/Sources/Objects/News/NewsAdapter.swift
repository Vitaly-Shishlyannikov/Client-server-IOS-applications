//
//  NewsAdapter.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 07.11.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import Foundation
import RealmSwift

final class NewsAdapter {
    
    var vkService = VKService()
    lazy var vkServiceProxy = VKServiceProxy(vkService: vkService)
    
    private var realmNotificationsToken = NotificationToken()
    
    func getNews(completion: @escaping ([News]) -> Void){
        
        self.vkServiceProxy.loadNews()
        
        guard let realm = try? Realm() else {return}
        let resultNews = realm.objects(NewsRaw.self)
        
        //        self.realmNotificationsToken.invalidate()
        
        let token = resultNews.observe { [weak self] (changes: RealmCollectionChange) in
            
            guard let self = self else {return}
            switch changes {
            case .update(let realmNews, _, insertions: _, modifications: _):
                var news: [News] = []
                for realmNews in realmNews {
                    let sourceID = realmNews.source_id
                    news.append(self.news(from: realmNews, with: sourceID))
                }
                
                
                self.realmNotificationsToken.invalidate()
                completion(news)
            case .error(let error):
                fatalError("\(error)")
            case .initial:
                break
            }
        }
        self.realmNotificationsToken = token

    }
    
    private func news(from news: NewsRaw, with sourceID: Int) -> News {
        
        var sourceName: String = ""
        var sourceImageUrl: String = ""
        
        if sourceID < 0 {
            if let group = self.getGroupSourceOfNewsFromRealm(sourceId: sourceID) {
                sourceName = group.name
                sourceImageUrl = group.photoURL
            }
        } else {
            if let user = self.getProfileSourceOfNewsFromRealm(sourceId: sourceID) {
                let fullName = user.firstName + " " + user.lastName
                sourceName = fullName
                sourceImageUrl = user.photoURL
            }
        }
        
        return News(sourceName: sourceName,
                    sourceImageUrl: sourceImageUrl,
                    newsText: news.text,
                    likesCount: news.likes,
                    commentCount: news.comments,
                    sharesCount: news.reposts,
                    viewsCount: news.views)
    }
    
    func getGroupSourceOfNewsFromRealm(sourceId: Int) -> SourceGroupRealm? {
        
        let sourceOfNews = try? Realm()
        let source = sourceOfNews?.objects(SourceGroupRealm.self).filter("id == %@", -sourceId).first
        return source
    }
    
    func getProfileSourceOfNewsFromRealm(sourceId: Int) -> SourceProfileRealm? {
        
        let sourceOfNews = try? Realm()
        let source = sourceOfNews?.objects(SourceProfileRealm.self).filter("id == %@", sourceId).first
        return source
    }
}
