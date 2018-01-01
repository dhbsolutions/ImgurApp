//
//  ImgurImageCell.swift
//  ImgurApp
//
//  Created by Dave Butler on 12/29/17.
//  Copyright © 2017 Dave Butler. All rights reserved.
//

import UIKit

class ImgurImageCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: CustomImageView!
    
    var imgurPhoto: ImgurPhoto? {
        didSet {
            titleLabel.text = imgurPhoto?.link
            
            setupThumbnailImage()

        }
    }
    
    func setupThumbnailImage() {
        if let thumbnailImageUrl = imgurPhoto?.link {
            imageView.loadImageUsingUrlString(thumbnailImageUrl)
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        imageView.image = nil
    }
}

