//
//  ThreePointsIndicator.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 10.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class ThreePointsIndicator: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addVIew()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addVIew()
    }
    
    override func prepareForInterfaceBuilder() {
        addVIew()
    }
    
    func addVIew() {
        let width: CGFloat = 60
        let height: CGFloat = 44
        let myImageView = UIImageView(frame: CGRect(x: super.bounds.width/2 - width/2 + 8, y: super.bounds.height/2 - height/2 + 22, width: width, height: height))
        var imageArray = [UIImage]()
        let size: CGFloat = 10
        for item in 0..<3 {
             // визуализатор изображения
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
            // в массив изображений добавляем элементы
            imageArray += [renderer.image { context in
                // создаем поле для рисования
                let imageContext = context.cgContext
                // рисуем 3 статичные точки
                let circleOne = UIBezierPath(ovalIn: CGRect(x: 5, y: 10, width: size, height: size))
                let circleTwo = UIBezierPath(ovalIn: CGRect(x: 20, y: 10, width: size, height: size))
                let circleThree = UIBezierPath(ovalIn: CGRect(x: 35, y: 10, width: size, height: size))
                // цвет для обводки
                imageContext.setStrokeColor(UIColor.darkGray.cgColor)
                // обводим статичные точки по контуру
                circleOne.stroke()
                circleTwo.stroke()
                circleThree.stroke()
                // цвет для заливки
                imageContext.setFillColor(UIColor.gray.cgColor)
                // коэффициент для сдвига бегущих точек = 0,1,2
                let spacing = CGFloat(item)
                // по очереди добавляем точки на поле для рисования context
                imageContext.addEllipse(in: CGRect(x: 5 + spacing*15, y: 10, width: size, height: size))
                // закрашиваем появляющиеся точки
                imageContext.fillPath()
                }]
            
            let image = UIImage.animatedImage(with: imageArray, duration: 1)
            myImageView.image = image
            myImageView.contentMode = .center
            super.addSubview(myImageView)
        }
    }
}

