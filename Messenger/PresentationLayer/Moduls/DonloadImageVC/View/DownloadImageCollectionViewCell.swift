//
//  DownloadImageCollectionViewCell.swift
//  Messenger
//
//  Created by Иван Базаров on 25.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class DownloadImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var downloadedImageView: UIImageView!
    var imageUploaded: Bool = false
    var url: URL!
}
