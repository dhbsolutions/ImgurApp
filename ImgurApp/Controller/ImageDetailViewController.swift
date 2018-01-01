//
//  ImageDetailViewController.swift
//  ImgurApp
//
//  Created by Dave Butler on 12/30/17.
//  Copyright © 2017 Dave Butler. All rights reserved.
//

import UIKit
import p2_OAuth2

class ImageDetailViewController: UIViewController {
    
    var index = 0
    
    var imgurPhoto:ImgurPhoto?
    var uploadInProgressAlert:UIAlertController = UIAlertController()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var photoImageView: CustomImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.showImage()
      
    }
    
    func showImage()
    {
        self.photoImageView.loadImageUsingUrlString((imgurPhoto?.link)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func deleteImage(_ sender: Any) {

        DispatchQueue.main.async{
            self.activityIndicator.startAnimating()
        }
        
        NetworkManager.shared().deleteImgurImage(imgurImage: self.imgurPhoto!, index: self.index) { (isSuccess) in
            
            DispatchQueue.global().async {
        
                DispatchQueue.main.async
                {
                    self.activityIndicator.stopAnimating()
                    if isSuccess {
                         self.navigationController?.popViewController(animated: true)
                    } else {
                        //DISPLAY ERROR
                    }
                }
                
            }
        }
    }
}

