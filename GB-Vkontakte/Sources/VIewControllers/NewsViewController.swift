//
//  NewsViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 06.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit
import SDWebImage

final class NewsViewController: UITableViewController {
    
    var news = [News]()
    
    var newsService = NewsAdapter()
    
    private var newsViewModels: [NewsViewModel] = []
    
    private let newsViewModelFactory = NewsViewModelFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NewsCellPost", bundle: nil),
                           forCellReuseIdentifier: NewsCell.reuseId)
        
        tableView.dataSource = self
        
        self.tableView.rowHeight = 150
        
        newsService.getNews { [weak self] news in
            
            guard let self = self else {return}
            
            self.news = news
            
            self.newsViewModels = self.newsViewModelFactory.constructViewModels(from: self.news)
            
            self.tableView?.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseId, for: indexPath) as? NewsCell else {return UITableViewCell()}
        
        cell.configure(with: newsViewModels[indexPath.row])
        
        return cell
    }
}
