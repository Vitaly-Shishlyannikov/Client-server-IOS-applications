//
//  ViewsControl.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 06.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

final class ViewsControl: UIControl {
    
    private var stackView: UIStackView!
    private var viewsIcon = UIImageView()
    private let viewsLabel = UILabel()
    private var viewsCount: Int = 98
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        viewsIcon.image = UIImage(named: "viewsIcon")
        viewsLabel.text = "\(viewsCount)"
        viewsLabel.textColor = UIColor.brandGrey
        setupConstraints()
        
        //MARK: to debug ViewsControl position uncomment two lines below
//            viewsIcon.layer.borderWidth = 1.0
//            viewsLabel.layer.borderWidth = 1.0
        
        stackView = UIStackView(arrangedSubviews: [viewsIcon, viewsLabel])
        
        self.addSubview(stackView)
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = true
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    private func setupConstraints() {
//        viewsIcon.translatesAutoresizingMaskIntoConstraints = true
//
//        NSLayoutConstraint.activate([
//            viewsIcon.widthAnchor.constraint(equalToConstant: bounds.width) ,
//            viewsIcon.heightAnchor.constraint(equalToConstant: bounds.height / 2)
////            viewsLabel.heightAnchor.constraint(equalTo: viewsIcon.heightAnchor, multiplier: 1)
//            ])
    }
    
    private func incrementViewsCount() {
        viewsCount += 1
        updateViewsCount(views: viewsCount)
    }
    
    private func decrementViewsCount() {
        viewsCount -= 1
        updateViewsCount(views: viewsCount)
    }
    
    func updateViewsCount(views: Int) {
        viewsCount = views
        viewsLabel.text = "\(viewsCount)"
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    }()
    
    @objc func onTap(_ sender: UIStackView) {
        incrementViewsCount()
    }
}
