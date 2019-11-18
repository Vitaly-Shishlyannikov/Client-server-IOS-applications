//
//  ExtensionInt.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 07.11.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

// расширение класса Int для перевода градусов в радианы
extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
