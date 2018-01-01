//
//  ViewController.swift
//  ImgurApp
//
//  Created by Dave Butler on 12/29/17.
//  Copyright © 2017 Dave Butler. All rights reserved.
//

import UIKit
import p2_OAuth2

class LoginViewController: UIViewController {

    var loader: OAuth2DataLoader?
    var oauth2 = OAuth2CodeGrant(settings: [
        Constants.clientIdKey: Constants.clientIdValue ,
        Constants.client_secretKey: Constants.client_secretValue,
        Constants.authorizeUrlKey: Constants.authorizeUrlValue,
        Constants.tokenUriKey: Constants.tokenUriValue,
        Constants.redirectUriKey: [Constants.redirectUriValue],
        Constants.verboseKey: true,
        Constants.keyChainKey: true
        ] as OAuth2JSON)
    
    @IBAction func loginClicked(_ sender: UIButton) {
        //method to allow to cancel authentication
        if oauth2.isAuthorizing {
            oauth2.abortAuthorization()
            return
        }
        oauth2.forgetTokens()
        
        //set flags for authentication
        oauth2.authConfig.authorizeEmbedded = true
        //oauth2.authConfig.ui.useSafariView = false
        oauth2.authConfig.authorizeContext = self
        
        
        // a loader object used to communicate with api server to send client_id receive code, then send
        // code and client secret
        let loader = OAuth2DataLoader(oauth2: oauth2)
        self.loader = loader
        let request = URLRequest(url: URL(string: Constants.userAllImagesUrlEndPoint)!)

        loader.perform(request: request) { response in
            do {
                
                if response.data != nil
                {
                    let json = try response.responseJSON()
                    print(json)
                    do
                    {
                        
                        // Would have rather used JSONDecoder, but took to long to figure out how to properly use
                        // so I did it the old way.
                        //let images = try JSONDecoder().decode([ImgurPhoto].self, from: response.data!)
                        
                        Images.shared().loadImages(json: json)
                        
                        
                       try self.dataLoaded()
                    }
                    catch let error
                    {
                        print("Error: Loading Images: \(error)")
                        
                        //TODO: SHOW ALERT TO USER.
                    }
                }
                else
                {
                    //No response? can't proceed - show intial screen again
                    print("no response data.")
                    self.didCancelOrFail(nil)
                }
                
            }
            catch let error {
                //error here - show initial page again.
                self.didCancelOrFail(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func dataLoaded() throws {
        DispatchQueue.main.async
            {
                //got data - now load next view controller
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc : ImgurCollectionViewController = storyboard.instantiateViewController(withIdentifier: "ImgurCollectionViewController") as! ImgurCollectionViewController
                
                //store token to NetworkManager singleton class
                NetworkManager.shared().token = self.oauth2.clientConfig.accessToken!
                
                let navigationController = UINavigationController(rootViewController: vc)
                
                self.present(navigationController, animated: true, completion: nil)
        }
    }

    func didCancelOrFail(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Authorization went wrong: \(error)")
            }
        }
    }

}

