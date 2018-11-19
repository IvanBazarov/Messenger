//
//  ProfileModel.swift
//  Messenger
//
//  Created by Иван Базаров on 21.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

protocol IProfile {
    var name: String { get set }
    var description: String { get set }
    var userImageData: Data { get set }
}

struct UserProfile: IProfile {
    var name: String
    var description: String
    var userImageData: Data
}
