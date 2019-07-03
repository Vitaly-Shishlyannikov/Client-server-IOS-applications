//
//  FullScreeenPhotoClass.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 17.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class FullScreenPhotoController: UIViewController  {
    
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var nextPhoto: UIImageView!
    weak var previousPhoto: UIImageView!
    
    var indexPathSelected = IndexPath()
    
    var photos: [PhotoModel] = []
    
    override func viewDidLoad() {
        getPhotos()
        setMainPhoto()
        setupView()
    }
    
    func getPhotos () {
        photos = PhotosServerEmulator.getPhotos() ?? []
    }
    
    func setMainPhoto () {
        let currentPhotoImage = UIImage(named: photos[indexPathSelected.row].photoPath)
        mainPhoto.image = currentPhotoImage
    }
    
    func setupView() {
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self,
                                                          action: #selector(swipeLeft(_:)))
            swipeLeftGestureRecognizer.direction = .left
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self,
                                                           action: #selector(swipeRight(_:)))
            swipeRightGestureRecognizer.direction = .right

        view.addGestureRecognizer(swipeLeftGestureRecognizer)
        view.addGestureRecognizer(swipeRightGestureRecognizer)
    }
    
    @objc func swipeLeft(_ sender: UITapGestureRecognizer) {
        if indexPathSelected.row < photos.count - 1 {
            
            let nextPhotoImage = UIImage(named: photos[indexPathSelected.row + 1].photoPath)
            nextPhoto.image = nextPhotoImage
            
            animatedPhotoChangeLeft()
            
            indexPathSelected.row += 1
        }
    }
    
    func animatedPhotoChangeLeft() {
        
        let animationScale = CABasicAnimation(keyPath: "transform.scale")
        animationScale.fromValue = 1
        animationScale.toValue = 0
        animationScale.duration = 1
        animationScale.beginTime = CACurrentMediaTime()
        animationScale.fillMode = CAMediaTimingFillMode.backwards
        
        let animationOpacity = CABasicAnimation(keyPath: "opacity")
        animationOpacity.toValue = 0
        animationOpacity.duration = 1
        animationOpacity.fillMode = CAMediaTimingFillMode.backwards
        
        self.mainPhoto.layer.add(animationScale, forKey: nil)
        self.mainPhoto.layer.add(animationOpacity, forKey: nil)
        
        let animationMoveLeft = CABasicAnimation(keyPath: "position.x")
        animationMoveLeft.fromValue = 500
        animationMoveLeft.toValue = self.view.frame.size.width / 2
        animationMoveLeft.duration = 1
        animationMoveLeft.beginTime = CACurrentMediaTime()
        
        self.nextPhoto.layer.add(animationMoveLeft, forKey: nil)
        
        setMainPhoto()
    }
    
    @objc func swipeRight(_ sender: UITapGestureRecognizer) {
        if indexPathSelected.row > 0 {
            
            let nextPhotoImage = UIImage(named: photos[indexPathSelected.row].photoPath)
            nextPhoto.image = nextPhotoImage
            
            indexPathSelected.row -= 1
            
            animatedPhotoChangeRight()
        }
    }
    
    func animatedPhotoChangeRight() {
        
        let animationScale = CABasicAnimation(keyPath: "transform.scale")
        animationScale.fromValue = 1
        animationScale.toValue = 0
        animationScale.duration = 1
        animationScale.beginTime = CACurrentMediaTime()
        animationScale.fillMode = CAMediaTimingFillMode.backwards
        
        let animationOpacity = CABasicAnimation(keyPath: "opacity")
        animationOpacity.toValue = 0
        animationOpacity.duration = 1
        animationOpacity.fillMode = CAMediaTimingFillMode.backwards
        
        self.nextPhoto.layer.add(animationScale, forKey: nil)
        self.nextPhoto.layer.add(animationOpacity, forKey: nil)
        
        let animationMoveRight = CABasicAnimation(keyPath: "position.x")
        animationMoveRight.fromValue = -500
        animationMoveRight.toValue = self.view.frame.size.width / 2
        animationMoveRight.duration = 1
        animationMoveRight.beginTime = CACurrentMediaTime()
        
        self.mainPhoto.layer.add(animationMoveRight, forKey: nil)
        
        setMainPhoto()
    }
}
