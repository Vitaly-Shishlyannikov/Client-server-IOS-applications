//
//  NewsViewModelFactory.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 08.11.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

final class NewsViewModelFactory {
    
    func constructViewModels(from news: [News]) -> [NewsViewModel] {
        return news.compactMap(self.viewModel)
    }
    
    private func viewModel(from news: News) -> NewsViewModel {
        
        let newsText = news.newsText
        let likesCount = news.likesCount
        let commentCount = news.commentCount
        let sharesCount = news.sharesCount
        let viewsCount = news.viewsCount
        
        let sourceLabeltext = news.sourceName
        
        var avatarImage: UIImage?
        
        if let url = URL(string: news.sourceImageUrl) {
            if let data = try? Data(contentsOf: url) {
                avatarImage = UIImage(data: data)
            }
        } else {
            avatarImage = UIImage(named: "defaultAvatar")
        }
        
        return NewsViewModel(sourceLabeltext: sourceLabeltext,
                             sourceImage: avatarImage,
                             newsText: newsText,
                             likesCount: likesCount,
                             commentCount: commentCount,
                             sharesCount: sharesCount,
                             viewsCount: viewsCount)
    }
}

