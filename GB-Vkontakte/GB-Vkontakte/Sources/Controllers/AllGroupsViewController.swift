//
//  AllGroupsViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class AllGroupsViewController: UITableViewController {
    
    var groups: [GroupModel] = [
        GroupModel(name: "Марсиане среди нас", avatarPath: "marsiane"),
        GroupModel(name: "Любители психостимуляторов", avatarPath: "psicho"),
        GroupModel(name: "Теории заговоров 18 века", avatarPath: "zagovor"),
        GroupModel(name: "Группа для тех, у кого живет домовой", avatarPath: "domovoi"),
        GroupModel(name: "Разработка IOS", avatarPath: "ios"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 70
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.reuseIdentifier, for: indexPath) as? GroupCell else { return UITableViewCell() }
        let avatarPath = groups[indexPath.row].avatarPath
        cell.groupAvatar.image = UIImage(named: avatarPath)
        cell.groupNameLabel.text = groups[indexPath.row].name
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            groups.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
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
    
    // MARK: - Navigation
    
    
//    @IBAction func addCity(segue: UIStoryboardSegue) {
//        if let controller = segue.source as? CitiesListViewController,
//            let indexPath = controller.tableView.indexPathForSelectedRow {
//            let city = controller.cities[indexPath.row]
//
//            guard !cities.contains(where: { $0.name == city.name }) else { return }
//
//            cities.append(city)
//            let newIndexPath = IndexPath(item: cities.count - 1, section: 0)
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
//        }
//    }
}
