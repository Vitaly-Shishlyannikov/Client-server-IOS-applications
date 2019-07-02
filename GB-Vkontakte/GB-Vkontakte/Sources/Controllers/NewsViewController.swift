//
//  NewsViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 06.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    
    var news: [NewsModel] = []

    func getNews () {
        news = NewsServerEmulator.getNews() ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNews()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil),
                           forCellReuseIdentifier: NewsCell.reuseId)
        
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 3000
        tableView.rowHeight = UITableView.automaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return news.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return news.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseId, for: indexPath) as? NewsCell else {return UITableViewCell()}
        
        cell.newsText.text = news[indexPath.row].newsText
        cell.sourceLabel.text = news[indexPath.row].newsSource
        let picturePath = news[indexPath.row].newsPicturePath
        let sourceImagePath = news[indexPath.row].newsSourceImage
        cell.newsImage.image = UIImage(named: picturePath)
        cell.sourceImage.image = UIImage(named: sourceImagePath)
        

        // Configure the cell...

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
