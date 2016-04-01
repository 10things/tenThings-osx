//
//  ProductHunt.swift
//  TenThings
//
//  Created by Joey on 2/23/16.
//  Copyright © 2016 joe. All rights reserved.
//

import Cocoa

class ProductHunt: NSObject {
    var Name: String = ""
    var Tagline: String = ""
    var VotesCount: Int = 0
    var RedirectUrl: String = ""
    
    init(data: JSON) {
        Name = data["Name"].stringValue
        Tagline = data["Tagline"].stringValue
        VotesCount = data["VotesCount"].intValue
        RedirectUrl = data["RedirectUrl"].stringValue
    }
}
