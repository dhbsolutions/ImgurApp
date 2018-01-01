//
//  Images.swift
//  ImgurApp
//
//  Created by Dave Butler on 12/30/17.
//  Copyright © 2017 Dave Butler. All rights reserved.
//

import UIKit
import p2_OAuth2

class Images: NSObject {
    var photos:[ImgurPhoto] = []
    var currentIndex = 0
    var accountName: String=""
    
    private static var sharedImages: Images = {
        let images = Images()
        return images
    }()

    class func shared() -> Images
    {
    return sharedImages
    }
    
    func loadImages(json: OAuth2JSON) {
        guard let jsonData = json["data"] as? [OAuth2JSON] else {return}
        Images.shared().photos.removeAll()
        
        for photo in jsonData
        {
            print(photo)
            let imgurPhoto: ImgurPhoto = ImgurPhoto.init(json: photo)!
            print(imgurPhoto)
            Images.shared().photos.append(imgurPhoto)
            Images.shared().accountName=imgurPhoto.account_url + " images"
        }
    }

    private override init()
    {
    }    
}
