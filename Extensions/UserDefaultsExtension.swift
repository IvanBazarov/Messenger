//
//  UserDefaultsExtension.swift
//  Messenger
//
//  Created by Иван Базаров on 14.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
extension UserDefaults {
    func color(forKey key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    func set(_ value: UIColor?, forKey key: String) {
        var colorData: Data?
        if let color = value {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        }
        set(colorData, forKey: key)
    }
}
