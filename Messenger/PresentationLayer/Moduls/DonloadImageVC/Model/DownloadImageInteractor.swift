//
//  DownloadImageInteractor.swift
//  Messenger
//
//  Created by Иван Базаров on 25.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

protocol IImageLoaderInteractor: class {
    var delegate: ImageLoaderDelegate? { get set }
    var imageStorage: IImageRequestsStorage? { get set }
    var imageDownloadManager: IImageDownloadManager { get }
    func loadImageURLs()
    func uploadImage(url: URL, completionImageHandler: @escaping (Data?) -> Void)
}
protocol ImageLoaderDelegate: class {
    func updateImages()
    func handleEror()
}
class ImageLoaderInteractor: IImageLoaderInteractor, NetworkManagerDelegate {
    weak var delegate: ImageLoaderDelegate?
    var imageStorage: IImageRequestsStorage?
    var imageDownloadManager: IImageDownloadManager
    var networkManager: NetworkManager<ImageRequestsStorageParser>
    init(networkManager: NetworkManager<ImageRequestsStorageParser>, imageDownloadManager: IImageDownloadManager) {
        self.imageDownloadManager = imageDownloadManager
        self.networkManager = networkManager
        self.networkManager.delegate = self
    }
    func loadImageURLs() {
        networkManager.send()
    }
    func uploadImage(url: URL, completionImageHandler: @escaping (Data?) -> Void) {
        imageDownloadManager.send(url: url, completionImageHandler: completionImageHandler)
    }
    func modelDidLoad<Model>(model: Model) {
        guard let imageStorage = model as? IImageRequestsStorage else { return }
        self.imageStorage = imageStorage
        DispatchQueue.main.async {
            self.delegate?.updateImages()
        }
    }
    func handleError(description: String) {
        delegate?.handleEror()
    }
}
