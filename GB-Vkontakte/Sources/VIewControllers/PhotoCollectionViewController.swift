//
//  PhotoCollectionViewController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    
    var friendNameForTitle: String = ""
    var selectedFriendID: String = ""
    
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VKService.loadFriendsPhotos(friendID: selectedFriendID){[weak self] photos in
            self?.photos = photos
            self?.collectionView?.reloadData()
        }
        
        title = friendNameForTitle
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {return UICollectionViewCell()}
        
        let photoPath = photos[indexPath.row].photoPath
        guard let url = URL(string: photoPath) else {return UICollectionViewCell()}
        let data = try? Data(contentsOf: url)
        if let imagedata = data {
            cell.photoImageView.image = UIImage(data: imagedata)
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullScreenSegue",
            let fullScreenPhotoController = segue.destination as? FullScreenPhotoController,
            let indexPaths = collectionView.indexPathsForSelectedItems,
            let indexPath = indexPaths.first {
                fullScreenPhotoController.indexPathSelected = indexPath
                fullScreenPhotoController.photos = photos
        }
    }
}
