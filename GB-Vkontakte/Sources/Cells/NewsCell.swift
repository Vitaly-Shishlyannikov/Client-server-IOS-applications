//
//  NewsCell.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 06.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

final class NewsCell: UITableViewCell {
    
    static var reuseId = "NewsCell"

    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var sourceImage: RoundAvatarView!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var likeControl: LikeControl!
    @IBOutlet weak var commentControl: CommentControl!
    @IBOutlet weak var sharesControl: SharesControl!
    @IBOutlet weak var viewsControl: ViewsControl!
    
    
    @IBOutlet weak var newsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
