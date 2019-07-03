//
//  NewsServerEmulator.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 06.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class NewsServerEmulator {
    
    static var news: [NewsModel] = [
        NewsModel(newsId: "111", newsSource: "Завьялов Семен", newsSourceImage: "semenzavyalov", newsText: "Я побывал в Африке! Видел много животных, красивых пейзажей и покатался на джипе", newsPicturePath: "africa", likesCount: 45, commentsCount: 2, sharesCount: 1, viewsCount: 80),
        NewsModel(newsId: "112", newsSource: "Клуб любителей Дмитрия Анатольевича", newsSourceImage: "medved", newsText: "Медведев побывал в Антарктиде! Видел много пингвинов, катался на снегоходе, пообещал полярникам улучшить условия жизни", newsPicturePath: "antarctida", likesCount: 999, commentsCount: 55, sharesCount: 44, viewsCount: 4444),
        ]
    
    static func getNews() -> [NewsModel]?{
        return news
    }
}

