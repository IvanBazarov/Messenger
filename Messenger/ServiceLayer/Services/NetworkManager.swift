//
//  NetworkManager.swift
//  Messenger
//
//  Created by Иван Базаров on 25.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

protocol INetworkManager {
    associatedtype Parser: IParser
    typealias Model = Parser.Model
    var config: RequestConfig<Parser> { get }
    var requestSender: IRequestSender { get }
    func send()
}
protocol NetworkManagerDelegate: class {
    func modelDidLoad<Model>(model: Model)
    func handleError(description: String)
}
class NetworkManager<Parser: IParser> {
    typealias Model = Parser.Model
    var config: RequestConfig<Parser>
    var requestSender: IRequestSender
    weak var delegate: NetworkManagerDelegate?
    init(requestSender: IRequestSender, config: RequestConfig<Parser>) {
        self.config = config
        self.requestSender = requestSender
    }
    func send() {
        requestSender.send(config: config) { (result) in
            switch result {
            case .succes(let model):
                self.delegate?.modelDidLoad(model: model)
            case .error(let description):
                self.delegate?.handleError(description: description)
            }
        }
    }
}
