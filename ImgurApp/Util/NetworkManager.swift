//
//  NetworkManager.swift
//  ImgurApp
//
//  Created by Dave Butler on 12/30/17.
//  Copyright © 2017 Dave Butler. All rights reserved.
//

import UIKit
import p2_OAuth2

class NetworkManager: NSObject {
    var token:String
    let session = URLSession.shared

    private static var sharedNetworkManager: NetworkManager = {
        let sharedNetworkManager = NetworkManager()
        return sharedNetworkManager
    }()
    
    class func shared() -> NetworkManager
    {
        return sharedNetworkManager
    }

    private override init()
    {
        self.token = ""
    }

    /*
     Delete Image
     */
    func loadImgurImages(completionHandler: @escaping (Bool) -> ())
    {
        var request = URLRequest(url: URL(string: Constants.userAllImagesUrlEndPoint)!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(NetworkManager.shared().token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode != 200 {
                    print("httpResponse= \(httpResponse.statusCode)")
                    completionHandler(false)
                    return
                }
            }
            
            if error != nil {
                print(error!)
                completionHandler(false)
                return
            }
            
            if data != nil
            {
                do
                {
                    //let json = try response.responseJSON()
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    print(json)
                    //let images = try JSONDecoder().decode([ImgurPhoto].self, from: response.data!)
                    
                    Images.shared().loadImages(json: json!)
                    completionHandler(true)
                }
                catch let error
                {
                    print("Error: Loading Images: \(error)")
                    
                    //TODO: SHOW ALERT TO USER.
                }

            
            //success
            completionHandler(true)
            }
        }.resume()
    }

    
    func uploadImageToImgur(image:UIImage, completionHandler: @escaping (Bool) -> ())
    {
        var request = URLRequest(url: URL(string: Constants.uploadImageUrlEndPoint)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(NetworkManager.shared().token)", forHTTPHeaderField: "Authorization")


        let imageData = UIImageJPEGRepresentation(image, 1)
        request.httpBody = imageData
        
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode != 200 {
                    print("httpResponse= \(httpResponse.statusCode)")
                    completionHandler(false)
                    return
                }
            }
            
            if error != nil {
                print(error!)
                completionHandler(false)
                return
            }
            //success
            completionHandler(true)
            
        }.resume()
    }
    
    
    /*
       Delete Image
     */
    func deleteImgurImage(imgurImage: ImgurPhoto, index:Int, completionHandler: @escaping (Bool) -> ())
    {
        var request = URLRequest(url: URL(string: Constants.deleteImageUrlEndPoint + imgurImage.id)!)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(NetworkManager.shared().token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode != 200 {
                    print("httpResponse= \(httpResponse.statusCode)")
                    completionHandler(false)
                    return
                }
            }
            
            if error != nil {
                print(error!)
                completionHandler(false)
                return
            }
            
                //remove image from photos array of ImgurImages
                Images.shared().photos.remove(at: index)
        
                //success
                completionHandler(true)
            
        }.resume()
    }
}

