//
//  HackerNews.swift
//  TenThings
//
//  Created by Joey on 2/23/16.
//  Copyright © 2016 joe. All rights reserved.
//

import Cocoa

class HackerNews: NSObject {
    var Title: String = ""
    var Url: String = ""
    var CommentUrl: String = ""
    
    init(data: JSON) {
        Title = data["Title"].stringValue
        Url = data["Url"].stringValue
        CommentUrl = data["CommentUrl"].stringValue
    }
}
