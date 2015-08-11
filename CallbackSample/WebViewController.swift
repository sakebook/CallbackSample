//
//  WebViewController.swift
//  CallbackSample
//
//  Created by 酒本 伸也 on 2015/07/28.
//  Copyright (c) 2015年 酒本 伸也. All rights reserved.
//

import Foundation
import UIKit

final class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var customNavigationItem: UINavigationItem!
    var article: QiitaArticle?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let article = article {
            customNavigationItem.title = article.title
            let url = NSURL(string: article.url)
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
        // TODO: else urlがなかった場合の処理
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("WebViewController: viewWillAppear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("WebViewController: viewDidAppear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("WebViewController: viewWillDisappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("WebViewController: viewDidDisappear")
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_COMEBACK_WEB_VIEW, object: nil)
    }

    @IBAction func clickClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


extension WebViewController {
    
    internal static func getController(board: UIStoryboard, article: QiitaArticle) -> UIViewController {
        let controller = board.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        controller.article = article
        return controller
    }
}