//
//  QiitaArticle.swift
//  CallbackSample
//
//  Created by 酒本 伸也 on 2015/07/23.
//  Copyright (c) 2015年 酒本 伸也. All rights reserved.
//

import Foundation

struct QiitaArticle {
    let url: String
    let title: String
    let tags: [String]
    let number: Int
    
    init(url: String, title: String, tagArray: NSArray) {
        self.url = url
        self.title = title
        
        self.tags = (tagArray as! Array<[String: AnyObject]>).map({(article) -> String in
            article["name"] as! String
        })
        
        self.number = Int(arc4random_uniform(UInt32(tags.count-1)))
    }
    
    init(url: String, title: String, tagName: String) {
        self.url = url
        self.title = title
        self.tags = [tagName]
        self.number = Int(arc4random_uniform(UInt32(tags.count-1)))
    }
    
}

