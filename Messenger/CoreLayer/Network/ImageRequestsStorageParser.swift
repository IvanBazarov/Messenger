//
//  ImageRequestsStorageParser.swift
//  Messenger
//
//  Created by Иван Базаров on 25.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

struct ImageRequestsStorageParser: IParser {
    typealias Model = ImageRequestsStorage
    func parse(data: Data) -> ImageRequestsStorage? {
        let jsonDecoder = JSONDecoder()
        let imageDownloader = try? jsonDecoder.decode(ImageRequestsStorage.self, from: data)
        return imageDownloader
    }
}
