//
//  Github.swift
//  TenThings
//
//  Created by Joey on 2/23/16.
//  Copyright © 2016 joe. All rights reserved.
//

import Cocoa

class Github: NSObject {
    var Language: String = ""
    var Repos = [GithubRepo]()
    
    init(data: JSON) {
        super.init()
        
        Language = data["Language"].stringValue
        if data["Repos"].array != nil {
            Repos = parseRepos(data["Repos"].array!)
        }
    }
    
    func parseRepos(data:[JSON]) -> [GithubRepo] {
        var repos = [GithubRepo]()
        for d in data {
            let r = GithubRepo(data: d)
            repos.append(r)
        }
        return repos
    }
}

class GithubRepo: NSObject {
    var Title: String = ""
    var Description: String = ""
    var Url: String = ""
    
    init(data: JSON) {
        Title = data["Title"].stringValue
        Description = data["Description"].stringValue
        Url = data["Url"].stringValue
    }
}
