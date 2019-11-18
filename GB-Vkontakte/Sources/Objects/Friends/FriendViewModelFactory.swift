//
//  FriendViewModelFactory.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 08.11.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

final class FriendViewModelFactory {
    
    func constructViewModels(from friends: [Friend]) -> [FriendViewModel] {
        return friends.compactMap(self.viewModel)
    }
    
    private func viewModel(from friend: Friend) -> FriendViewModel {
        
        let id = friend.id
        let firstName = friend.firstName
        let lastName = friend.lastName
        let fullName = friend.firstName + " " + friend.lastName
        var avatarImage: UIImage?
    
        if let url = URL(string: friend.photo) {
            if let data = try? Data(contentsOf: url) {
                avatarImage = UIImage(data: data)
            }
        } else {
            avatarImage = UIImage(named: "defaultAvatar")
        }
        
        return FriendViewModel(id: id, firstName: firstName, lastName: lastName, fullName: fullName, avatarImage: avatarImage)
    }
}
