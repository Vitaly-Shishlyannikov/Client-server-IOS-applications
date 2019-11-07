//
//  LikeControl.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 28.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

final class LikeControl: UIControl {
    
    private var stackView: UIStackView!
    private var likeButton = HeartButton()
    private let likesLabel = UILabel()
    private var likesCount: Int = 14
    private var liked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        likeButton.isUserInteractionEnabled = false
        likesLabel.text = "\(likesCount)"
        likesLabel.textColor = UIColor.brandGrey
        setupConstraints()
        
      //  MARK: to debug LikeControl position uncomment two lines below
//            likeButton.layer.borderWidth = 1.0
//            likesLabel.layer.borderWidth = 1.0
        
        stackView = UIStackView(arrangedSubviews: [likeButton, likesLabel])
        self.addSubview(stackView)
        stackView.distribution = .fillEqually
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    private func setupConstraints() {
        likesLabel.heightAnchor.constraint(equalTo: likeButton.heightAnchor, multiplier: 1)
    }
    
    private func incrementLikesCount() {
        likesCount += 1
        updateLikesCount(likes: likesCount)
    }
    
    private func decrementLikesCount() {
        likesCount -= 1
        updateLikesCount(likes: likesCount)
    }
    
    func updateLikesCount(likes: Int) {
        likesCount = likes
        likesLabel.text = "\(likesCount)"
    }
    
    private func like() {
        if !liked {
            likeButton.liked = true
            likeButton.setNeedsDisplay()
            incrementLikesCount()
            liked = true
            likesLabel.textColor = UIColor.brandRed
        } else {
            likeButton.liked = false
            likeButton.setNeedsDisplay()
            decrementLikesCount()
            liked = false
            likesLabel.textColor = UIColor.brandGrey
        }
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    }()
    
    @objc func onTap(_ sender: HeartButton) {
        like()
        animateLikeButton()
    }
    
    
    private func animateLikeButton() {
        let animation = CASpringAnimation(keyPath: "transform.rotation")
        animation.fromValue = Double.pi / 2
        animation.toValue = Double.pi * 2
        animation.stiffness = 100
        animation.mass = 1
        animation.duration = 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.likeButton.layer.add(animation, forKey: nil)
    }
}

