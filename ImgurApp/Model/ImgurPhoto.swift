//
//  ImgurPhoto.swift
//  ImgurApp
//
//  Created by Dave Butler on 12/29/17.
//  Copyright © 2017 Dave Butler. All rights reserved.
//

import UIKit

struct ImgurPhoto: Decodable {
    
    public let id: String
    public let link: String
    public let description: String
    public let type: String
    public let deletehash: String
    public let name: String
    public let account_url: String

    let title: String
    
    init?(json: [String:Any]) {
        guard let id = json["id"] as? String? ?? "",
            let title = json["title"] as? String? ?? "",
            let link = json["link"] as? String? ?? "",
            let description = json["description"] as? String? ?? "",
            let type = json["type"] as? String? ?? "",
            let deletehash = json["deletehash"] as? String? ?? "",
            let name = json["name"] as? String? ?? "",
            let account_url = json["account_url"] as? String? ?? ""
        else { return nil }

        self.id = id
        self.title = title
        self.link = link
        self.description = description
        self.type = type
        self.deletehash = deletehash
        self.name = name
        self.account_url = account_url
    }
    
}

