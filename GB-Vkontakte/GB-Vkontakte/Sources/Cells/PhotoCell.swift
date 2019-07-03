//
//  PhotoCollectionViewCell.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    static let reuseIdentifier = "PhotoCell"
    
    @IBOutlet weak var likeControl: LikeControl!
    
}
