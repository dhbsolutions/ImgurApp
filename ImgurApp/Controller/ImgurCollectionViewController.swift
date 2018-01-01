//
//  ImgurCollectionViewController.swift
//  ImgurApp
//
//  Created by Dave Butler on 12/30/17.
//  Copyright © 2017 Dave Butler. All rights reserved.
//

import UIKit
import p2_OAuth2

class ImgurCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let imagePicker = UIImagePickerController()
    
    var localPath: String?
    var uploadInProgressAlert:UIAlertController = UIAlertController()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //prepare data for next view controller when using segue.
        //pass index of the photo to show in detail.
        if let cell = sender as? ImgurImageCell,
           let indexPath = collectionView?.indexPath(for: cell),
           let detailViewController = segue.destination as? ImageDetailViewController
        {
            detailViewController.index = indexPath.row
            detailViewController.imgurPhoto = cell.imgurPhoto
        }
    }
    
    override func viewDidLoad()
    {
        //delegate for the imagePicker
        imagePicker.delegate = self

        //logic to run when call back button from navigation controller
        let backItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(ImgurCollectionViewController.back))
        
        self.navigationItem.leftBarButtonItem = backItem
        
        //alert user if no photos are available.
        if Images.shared().photos.count == 0
        {
            print("No Images Found.")
            
            let alert = UIAlertController(title: "No Images",
                                          message: "No Images found, please add images.",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            self.title = Images.shared().accountName
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //reload data in case photos were deleted or either uploaded.
        self.collectionView?.reloadData()
    }
    
    @objc func back()
    {
        //back to login VC.
        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : LoginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: Any)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //after user picking image - make sure it is an UIImage
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            //show alert to user stating that image is being uploaded
            DispatchQueue.main.async{
                self.activityIndicator.startAnimating()
            }
            
            NetworkManager.shared().uploadImageToImgur(image: image, completionHandler:
                { (isSuccess) in
                    //after finished uploading image - reload data to refresh new image
                    
                    DispatchQueue.global().async {
                        
                        DispatchQueue.main.async
                            {
                                self.activityIndicator.stopAnimating()
                                if isSuccess {
                                    self.reloadCollectionData()
                                } else {
                                    //DISPLAY ERROR
                                }
                        }
                        
                    }
            })
        }
        else
        {
            print("Something went wrong")
        }
        
        //dismiss image picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    func reloadCollectionData() -> Void
    {
        NetworkManager.shared().loadImgurImages(completionHandler:
            { (isSuccess) in
                //after finished uploading image - reload data to refresh new image
                
                DispatchQueue.global().async {
                    
                    DispatchQueue.main.async
                        {
                            self.collectionView?.reloadData()
                            self.activityIndicator.stopAnimating()
                            if isSuccess {
                                self.collectionView?.reloadData()
                            } else {
                                //DISPLAY ERROR
                            }
                    }
                    
                }
        })
    }
    
    // user started to pick image but hit cancel.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("user cancelled image picking")
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDataSource
extension ImgurCollectionViewController
{
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return Images.shared().photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgurImageCell", for: indexPath) as! ImgurImageCell
        
        //get ImgurImage object and store reference in cell
        let imgurPhoto: ImgurPhoto = Images.shared().photos[indexPath.row]
        cell.imgurPhoto = imgurPhoto

        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 5
        
        return cell
    }
}

