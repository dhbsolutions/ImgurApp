//
//  Constants.swift
//  ImgurApp
//
//  Created by Dave Butler on 12/29/17.
//  Copyright © 2017 Dave Butler. All rights reserved.
//

import UIKit

/*
 a struct to hold all of the constants for the project.
 */
struct Constants {
    //section: Oauth2 properties
    static let clientIdKey = "client_id"
    static let clientIdValue = "0f5958cb5f66429"
    static let client_secretKey = "client_secret"
    static let client_secretValue = "3044de8eac80be5793f33b31487de1f16d6cd95b"
    static let authorizeUrlKey = "authorize_uri"
    static let authorizeUrlValue = "https://api.imgur.com/oauth2/authorize"
    static let tokenUriKey = "token_uri"
    static let tokenUriValue = "https://api.imgur.com/oauth2/token"
    static let redirectUriKey = "redirect_uris"
    static let redirectUriValue = "imgurapp://oauth/callback"
    static let verboseKey = "verbose"
    static let keyChainKey = "keychain"
    //imgurapp://oauth/callback
    //section: api url for user images
    static let userAllImagesUrlEndPoint = "https://api.imgur.com/3/account/me/images/0"
    static let uploadImageUrlEndPoint = "https://api.imgur.com/3/upload"
    static let deleteImageUrlEndPoint = "https://api.imgur.com/3/image/"
    
    //ImgurServiceManager
    static let headerAuthorizationKey = "Authorization"
    static let headerContentTypeKey = "Content-type"
    static let headerMultipartFormDataValue = "multipart/form-data"
}

