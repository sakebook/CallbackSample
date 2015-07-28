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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://yahoo.co.jp")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
        let closeButton = UIButton(frame: CGRectMake(0, 0, 72, 72))
        closeButton.setTitle("閉じる", forState: UIControlState.Normal)
        
        closeButton.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(closeButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    internal func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}