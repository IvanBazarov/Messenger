//
//  Requests.swift
//  Messenger
//
//  Created by Иван Базаров on 25.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

struct PixabayRequest: IRequest {
    var urlRequest: URLRequest?
    init(apiKey: String) {
        let urlString = "https://pixabay.com/api/?key=\(apiKey)"
        let url = URL(string: urlString)!
        urlRequest = URLRequest(url: url)
    }
}

struct RequestsFactory {
    struct ImageLoaderFactory {
        static func imageDownloaderConfig() -> RequestConfig<ImageRequestsStorageParser> {
            return RequestConfig<ImageRequestsStorageParser>(request: PixabayRequest(apiKey: "10799227-12eb29be8a38a5ac09ecd1497"), parser: ImageRequestsStorageParser())
        }
    }
}
