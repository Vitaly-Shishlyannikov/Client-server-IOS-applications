//
//  SessionSingleton.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 27.06.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

// класс для хранения данных о сессии
final class Session {
    
    static let instance = Session()
    
    private init(){}
    
    var token: String = ""
    var userId: Int = 0
    
}
