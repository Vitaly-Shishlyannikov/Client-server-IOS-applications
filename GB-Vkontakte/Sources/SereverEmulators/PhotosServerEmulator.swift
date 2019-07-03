//
//  PhotosServerEmulator.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 17.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class PhotosServerEmulator {
    
    static var photos: [PhotoModel] = [
        PhotoModel(photoPath: "photo1"),
        PhotoModel(photoPath: "photo2"),
        PhotoModel(photoPath: "photo3"),
        PhotoModel(photoPath: "photo4"),
        ]
    
    static func getPhotos () -> [PhotoModel]? {
        return photos
    }
}
