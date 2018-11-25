//
//  RequestConfig.swift
//  Messenger
//
//  Created by Иван Базаров on 25.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

enum RequestResult<T> {
    case succes(T)
    case error(String)
}

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}

struct RequestConfig<Parser: IParser> {
    var request: IRequest
    var parser: Parser
}
