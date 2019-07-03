//
//  NewsCell.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 06.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    static var reuseId = "NewsCell"

    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var sourceImage: RoundAvatarView!
    @IBOutlet weak var newsText: UILabel!
    
    @IBOutlet weak var newsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
