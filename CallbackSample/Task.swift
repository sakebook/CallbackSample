//
//  Task.swift
//  CallbackSample
//
//  Created by 酒本 伸也 on 2015/07/14.
//  Copyright (c) 2015年 酒本 伸也. All rights reserved.
//

import Foundation

protocol TaskDelegate {
    func complete(qiitaArticle: QiitaArticle)
    func failed(error: NSError)
}

final class Task {
    
    var delegate: TaskDelegate?
    
    func fetchLatestArticle(tagName: String) {
        let url = NSURL(string: "https://qiita.com/api/v1/tags/\(tagName)/items")
        let request = NSURLRequest(URL: url!)
        // Delegateのメソッドは今回使わないのでnilを入れる
        let connection = NSURLConnection(request: request, delegate: nil, startImmediately: false)
        NSURLConnection.sendAsynchronousRequest(request,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: result)
    }
}


// MARK: - Private
extension Task {
    private func result(response: NSURLResponse!, data: NSData!, error: NSError!) {
        if error == nil {
            let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSArray
            // 初めの記事を取得
            let article = jsonArray.objectAtIndex(0) as! [String: AnyObject]

            if let url = article["url"] as? String, let title = article["title"] as? String, let tags = article["tags"] as? NSArray {
                let qiitaArticle = QiitaArticle(url: url, title: title, tagArray: tags)
                self.delegate?.complete(qiitaArticle)
            } else {
                let er = NSError(domain: "not found url and title", code: 404, userInfo: nil)
                self.delegate?.failed(er)
            }
        } else {
            self.delegate?.failed(error)
        }
    }
}
