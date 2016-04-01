//
//  TenThings.swift
//  TenThings
//
//  Created by Joey on 2/23/16.
//  Copyright © 2016 joe. All rights reserved.
//

import Cocoa

class TenThings: NSObject {
    var HN = [HackerNews]()
    var GH = [Github]()
    var PH = [ProductHunt]()
    
    init(data: JSON) {
        super.init()
        
        if data["HN"].array != nil {
            HN = parseHN(data["HN"].array!)
        }
        
        if data["GH"].array != nil {
            GH = parseGH(data["GH"].array!)
        }
        
        if data["PH"].array != nil {
            PH = parsePH(data["PH"].array!)
        }
    }
    
    func parseHN(data:[JSON]) -> [HackerNews] {
        var hnArr = [HackerNews]()
        for d in data {
            let hn = HackerNews(data: d)
            hnArr.append(hn)
        }
        return hnArr
    }
    
    func parseGH(data:[JSON]) -> [Github] {
        var ghArr = [Github]()
        for d in data {
            let gh = Github(data: d)
            ghArr.append(gh)
        }
        return ghArr
    }
    
    func parsePH(data:[JSON]) -> [ProductHunt] {
        var phArr = [ProductHunt]()
        for d in data {
            let ph = ProductHunt(data: d)
            phArr.append(ph)
        }
        return phArr
    }
    
    func findGithubRepoByLanguage(lan: String) -> [GithubRepo] {
        for gh in GH {
            if gh.Language == lan {
                return gh.Repos
            }
        }
        return [GithubRepo]()
    }
}
