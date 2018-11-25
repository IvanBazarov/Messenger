//
//  ImageDownloader.swift
//  Messenger
//
//  Created by Иван Базаров on 25.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

protocol IImageRequestsStorage {
    var imagesURL: [ImageRequest] { get }
}

struct ImageRequestsStorage: IImageRequestsStorage, Codable {
    var imagesURL: [ImageRequest]
    enum CodingKeys: String, CodingKey {
        case imagesURL = "hits"
    }
}

struct ImageRequest: Codable {
    var url: URL?
    enum CodingKeys: String, CodingKey {
        case url = "userImageURL"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url)
    }
}
