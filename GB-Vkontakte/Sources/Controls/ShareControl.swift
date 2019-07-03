//
//  ShareControl.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 06.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class SharesControl: UIControl {
    
    private var stackView: UIStackView!
    private var sharesIcon = UIImageView()
    private let sharesLabel = UILabel()
    private var sharesCount: Int = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        sharesIcon.image = UIImage(named: "shareIcon")
        sharesLabel.text = "\(sharesCount)"
        sharesLabel.textColor = UIColor.gray
        setupConstraints()
        
        //  MARK: to debug LikeControl position uncomment two lines below
        //            likeButton.layer.borderWidth = 1.0
        //            likesLabel.layer.borderWidth = 1.0
        
        stackView = UIStackView(arrangedSubviews: [sharesIcon, sharesLabel])
        self.addSubview(stackView)
        stackView.distribution = .fillEqually
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    func setupConstraints() {
        sharesLabel.heightAnchor.constraint(equalTo: sharesIcon.heightAnchor, multiplier: 1)
    }
    
    func incrementSharesCount() {
        sharesCount += 1
        updateSharesCount(shares: sharesCount)
    }
    
    func decrementSharesCount() {
        sharesCount -= 1
        updateSharesCount(shares: sharesCount)
    }
    
    func updateSharesCount(shares: Int) {
        sharesCount = shares
        sharesLabel.text = "\(sharesCount)"
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    }()
    
    @objc func onTap(_ sender: UIStackView) {
        incrementSharesCount()
    }
}
