//
//  CommentControl.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 06.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class CommentControl: UIControl {
    
    private var stackView: UIStackView!
    private var commentsIcon = UIImageView()
    private let commentsLabel = UILabel()
    private var commentsCount: Int = 7
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        commentsIcon.image = UIImage(named: "commentsIcon")
        commentsLabel.text = "\(commentsCount)"
        commentsLabel.textColor = UIColor.gray
        setupConstraints()
        
        //  MARK: to debug LikeControl position uncomment two lines below
        //            likeButton.layer.borderWidth = 1.0
        //            likesLabel.layer.borderWidth = 1.0
        
        stackView = UIStackView(arrangedSubviews: [commentsIcon, commentsLabel])
        self.addSubview(stackView)
        stackView.distribution = .fillEqually
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    func setupConstraints() {
        commentsLabel.heightAnchor.constraint(equalTo: commentsIcon.heightAnchor, multiplier: 1)
    }
    
    func incrementCommentsCount() {
        commentsCount += 1
        updateCommentsCount(comments: commentsCount)
    }
    
    func decrementCommentsCount() {
        commentsCount -= 1
        updateCommentsCount(comments: commentsCount)
    }
    
    func updateCommentsCount(comments: Int) {
        commentsCount = comments
        commentsLabel.text = "\(commentsCount)"
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    }()
    
    @objc func onTap(_ sender: UIStackView) {
        incrementCommentsCount()
    }
}
