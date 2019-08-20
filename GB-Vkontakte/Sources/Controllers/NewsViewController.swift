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

class NewsViewController: UITableViewController {
    
    var news = [News]()
    
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
        
        cell.newsText.text = news[indexPath.row].text
        cell.sourceLabel.text = String(news[indexPath.row].source_id)
        
        let sourceId = news[indexPath.row].source_id
        let realm = try? Realm()
        
        if sourceId < 0 {
            let group = realm?.objects(SourceGroupRealm.self).filter("id == %@", -sourceId).first
            cell.sourceLabel.text = group?.name ?? "default name"
            cell.sourceImage.sd_setImage(with: URL(string: ((group?.photoURL)!)), placeholderImage: UIImage(named: "defaultAvatar"))
        } else {
            let user = realm?.objects(SourceProfileRealm.self).filter("id == %@", sourceId).first
            cell.sourceLabel.text = user?.fullName ?? "default name"
            cell.sourceImage.sd_setImage(with: URL(string: ((user?.photoURL)!)), placeholderImage: UIImage(named: "defaultAvatar"))
        }
        
//        news[indexPath.row].
//        let picturePath = news[indexPath.row].photo
//        let sourceImagePath = news[indexPath.row].newsSourceImage
//        cell.newsImage.image = UIImage(named: picturePath)
//        cell.sourceImage.image = UIImage(named: sourceImagePath)

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
