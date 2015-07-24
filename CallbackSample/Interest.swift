//
//  Interest.swift
//  CallbackSample
//
//  Created by 酒本 伸也 on 2015/07/22.
//  Copyright (c) 2015年 酒本 伸也. All rights reserved.
//

import Foundation
import UIKit

struct Interest {
    let name: String
    let color: UIColor
    
    enum Type: String {
        case Swift = "Swift"
        case Android = "Android"
    }
    
    init(type: Type) {
        switch(type) {
        case .Swift:
            name = "Swift"
            color = UIColor.orangeColor()
        case .Android:
            name = "Android"
            color = UIColor.greenColor()
        }
    }
    
    init(article: QiitaArticle) {
        if let type = Type(rawValue: article.tags[article.number]) {
            switch(type) {
            case .Swift:
                name = "Swift"
                color = UIColor.orangeColor()
            case .Android:
                name = "Android"
                color = UIColor.greenColor()
            }
        } else {
            name = article.tags[article.number]
            color = UIColor(red: CGFloat(arc4random_uniform(UInt32(255)))/255, green: CGFloat(arc4random_uniform(UInt32(255)))/255, blue: CGFloat(arc4random_uniform(UInt32(255)))/255, alpha: 1)
        }
    }
}