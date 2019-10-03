//
//  NewsViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 06.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

final class NewsViewController: UITableViewController {
    
    var news = [News]()
    
    let realmSourcesOfNews = try? Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NewsCellPost", bundle: nil),
                           forCellReuseIdentifier: NewsCell.reuseId)
        
        tableView.dataSource = self
        
        self.tableView.rowHeight = 150

        VKService.loadNews(){[weak self] news in
            self?.news = news
            self?.tableView?.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return news.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseId, for: indexPath) as? NewsCell else {return UITableViewCell()}
        
        cell.likeControl.updateLikesCount(likes: news[indexPath.row].likes)
        cell.commentControl.updateCommentsCount(comments: news[indexPath.row].comments)
        cell.sharesControl.updateSharesCount(shares: news[indexPath.row].reposts)
        cell.viewsControl.updateViewsCount(views: news[indexPath.row].views)
        
        cell.newsText.text = news[indexPath.row].text
        
        let sourceId = news[indexPath.row].source_id
        
        if sourceId < 0 {
            let group = realmSourcesOfNews?.objects(SourceGroupRealm.self).filter("id == %@", -sourceId).first
            cell.sourceLabel.text = group?.name ?? "default name"
            cell.sourceImage.sd_setImage(with: URL(string: ((group?.photoURL)!)), placeholderImage: UIImage(named: "defaultAvatar"))
        } else {
            let user = realmSourcesOfNews?.objects(SourceProfileRealm.self).filter("id == %@", sourceId).first
            cell.sourceLabel.text = user?.fullName ?? "default name"
            cell.sourceImage.sd_setImage(with: URL(string: ((user?.photoURL)!)), placeholderImage: UIImage(named: "defaultAvatar"))
        }
        return cell
    }
}
