//
//  ViewController.swift
//  CallbackSample
//
//  Created by 酒本 伸也 on 2015/07/12.
//  Copyright (c) 2015年 酒本 伸也. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    var comebackFromSafari = false
    let swiftButton = UIButton(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width , UIScreen.mainScreen().bounds.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupButton()
        swiftButton.enabled = false
        
        let task = Task()
        task.delegate = self
        task.fetchLatestArticle("swift")
        
        // バックグラウンドから復帰した際のObserver
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "comeback:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController {
    internal func fetchSwift(sender: AnyObject) {
        swiftButton.enabled = false
        println("fetchSwift")
        let task = Task()
        task.delegate = self
        task.fetchLatestArticle("swift")
    }
    
    internal func comeback(sender: AnyObject) {
        println("becomeActive")
        
        // Safariで記事を開いた後に戻った時のみ呼ばれる
        if comebackFromSafari {
            comebackFromSafari = false
            
            ClosureAlert.showAlert(self, title: "記事はどうだった？", message: "Androidも興味ある？",
                completion: {(isPositive) -> Void in
                    if isPositive {
                        println("Androidも興味があるらしい")
                        let task = Task()
                        task.delegate = self
                        task.fetchLatestArticle("Android")
                    } else {
                        println("Androidには興味がないらしい")
                    }
                }
            )
        }
    }
}


// MARK: - Private
extension ViewController {
    func setupButton() {
        swiftButton.backgroundColor = UIColor.orangeColor()
        swiftButton.setTitle("Swift", forState: .Normal)
        swiftButton.addTarget(self, action: "fetchSwift:", forControlEvents: .TouchUpInside)
        self.view.addSubview(swiftButton)
    }
}


// MARK: - TaskDelegate
extension ViewController: TaskDelegate {
    func complete(qiitaArticle: QiitaArticle) {
        swiftButton.enabled = true
        println("TaskDelegate complete: \(qiitaArticle)")
        
        // クリック時に呼ばれるメソッドを定義
        let completeAction: (Bool) -> Void = {
            (isPositive) -> Void in
            if isPositive {
                println("Safariを開こうとする")
                if let url = NSURL(string: qiitaArticle.url) {
                    println("Safariを開く")
                    self.comebackFromSafari = true
                    UIApplication.sharedApplication().openURL(url)
                }
            } else {
                println("Safariを開かない")
            }
        }
        
        // 実行するのはアラート選択時なのでcompleteActionに`()`はつけない。
        ClosureAlert.showAlert(self, title: "最新の記事", message: qiitaArticle.title,
            completion: completeAction
        )
    }
    
    func failed(error: NSError) {
        swiftButton.enabled = true
        println("TaskDelegate failed: \(error.debugDescription)")
    }
}
