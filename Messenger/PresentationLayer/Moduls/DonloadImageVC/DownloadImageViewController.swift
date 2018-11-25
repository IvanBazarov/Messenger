//
//  DownloadImageViewController.swift
//  Messenger
//
//  Created by Иван Базаров on 25.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class DownloadImageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ImageLoaderDelegate {
    var assembly: IPresentationAssembly!
    var imageLoaderInteractor: IImageLoaderInteractor!
    @IBOutlet var collectionView: UICollectionView!
    let space: CGFloat = 10
    let itemsPerRow = 3
    let reuseId = "imageCell"
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImages()
    }
    func downloadImages() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        imageLoaderInteractor.loadImageURLs()
    }
    func updateImages() {
        stopIndicatorAnimation()
        collectionView.reloadData()
    }
    func stopIndicatorAnimation() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
    func handleEror() {
        stopIndicatorAnimation()
        let alert = UIAlertController(title: "Не удалось загрузить изображения",
                                      message: "Проверьте интенет соединение",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func closeImageLoader(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToProfile", sender: nil)
    }
    @IBAction func refreshImagesList(_ sender: UIBarButtonItem) {
        updateImages()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToProfile" {
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first,
                let cell = collectionView.cellForItem(at: indexPath) as? DownloadImageCollectionViewCell,
                let profileVC = segue.destination as? ProfileViewController else { return }
            if cell.imageUploaded {
                profileVC.profileImageView.image = cell.downloadedImageView.image
                profileVC.isPhotoSelected = true
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    //CollectionView setup block
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageLoaderInteractor.imageStorage?.imagesURL.count ?? 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId,
                                                            for: indexPath) as?
            DownloadImageCollectionViewCell else { return UICollectionViewCell() }
        let imageRequest = imageLoaderInteractor.imageStorage!.imagesURL[indexPath.row]
        guard let imageUrl = imageRequest.url else { return cell }
        cell.url = imageUrl
        imageLoaderInteractor.uploadImage(url: imageUrl) { (data) in
            if let data = data, let image = UIImage(data: data), imageUrl == cell.url {
                DispatchQueue.main.async {
                    cell.downloadedImageView.image = image
                    cell.imageUploaded = true
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DownloadImageCollectionViewCell else { return }
        if cell.imageUploaded {
            performSegue(withIdentifier: "unwindToProfile", sender: cell.downloadedImageView.image)
        } else {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

extension DownloadImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = space * CGFloat(itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem * 0.8)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
}
