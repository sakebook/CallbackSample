//
//  ViewController.swift
//  CallbackSample
//
//  Created by 酒本 伸也 on 2015/07/12.
//  Copyright (c) 2015年 酒本 伸也. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    var openedArticle: QiitaArticle?
    let NOTIFICATION_COMEBACK_ANDROID = "ComebackAndroid"
    let interestButton = UIButton(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width , UIScreen.mainScreen().bounds.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        fetchArticleWihtTagName("Swift")
        
        // バックグラウンドから復帰した際のObserver
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "comeback:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("ViewController: viewWillAppear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("ViewController: viewDidAppear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("ViewController: viewWillDisappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("ViewController: viewDidDisappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
}


extension ViewController {
    
    /**
    画面をタッチした際に呼ばれる
    */
    internal func fetchCurrentInterest(sender: AnyObject) {
        fetchArticleWihtTagName(interestButton.titleLabel?.text ?? "Swift")
    }
    
    /**
    バックグラウンドから復帰した時に呼ばれる
    */
    internal func comeback(notification: NSNotification) {
        println("becomeActive")
        // Safariで記事を開いた後に戻った時のみ呼ばれる
        if let article = openedArticle {
            openedArticle = nil
            ClosureAlert.showAlert(self, title: "記事はどうだった？", message: "\(article.tags[article.number])も興味ある？",
                completion: {(isPositive) -> Void in
                    if isPositive {
                        println("ほかにも興味があるらしい")
                        let interest = Interest(article: article)
                        self.chengeButtonDesign(interest)
                        self.fetchArticleWihtTagName(interest.name)
//                        NSNotificationCenter.defaultCenter().addObserver(self, selector: "comebackAndroid:", name: self.NOTIFICATION_COMEBACK_ANDROID, object: nil)
                    } else {
                        println("ほかには興味がないらしい")
                        self.chengeButtonDesign(Interest(type: .Swift))
                    }
                }
            )
        }
    }
    
    internal func comebackAndroid(sender: AnyObject) {
        println("comebackAndroid: method")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFICATION_COMEBACK_ANDROID, object: nil)
    }
}


// MARK: - Private
extension ViewController {
    
    /**
    全面サイズのボタンの初期化
    */
    func setupButton() {
        interestButton.backgroundColor = UIColor.orangeColor()
        interestButton.setTitle("Swift", forState: .Normal)
        interestButton.addTarget(self, action: "fetchCurrentInterest:", forControlEvents: .TouchUpInside)
        self.view.addSubview(interestButton)
    }
    
    func chengeButtonDesign(interest: Interest) {
        UIView.animateWithDuration(0.5, animations: {
            self.interestButton.backgroundColor = interest.color
            self.interestButton.setTitle(interest.name, forState: .Normal)
        })
    }
    
    /**
    指定したTagの記事を取得しに行く
    */
    func fetchArticleWihtTagName(tagName: String) {
        let task = Task()
        task.delegate = self
        task.fetchLatestArticle(tagName)
        interestButton.enabled = false
    }
}


// MARK: - TaskDelegate
extension ViewController: TaskDelegate {
    func complete(qiitaArticle: QiitaArticle) {
        println("TaskDelegate complete: \(qiitaArticle)")
        
        // クリック時に呼ばれるメソッドを定義
        let completeAction: (Bool) -> Void = {
            (isPositive) -> Void in
            self.interestButton.enabled = true
            if isPositive {
                println("Safariを開こうとする")
                if let url = NSURL(string: qiitaArticle.url) {
                    println("Safariを開く")
                    self.openedArticle = qiitaArticle
                    UIApplication.sharedApplication().openURL(url)
                }
            } else {
                println("Safariを開かない")
                let controller = WebViewController.getController(self.storyboard!, article: qiitaArticle)
                
                
//                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
        
        // 実行するのはアラート選択時なのでcompleteActionに`()`はつけない。
        ClosureAlert.showAlert(self, title: "最新の記事", message: qiitaArticle.title,
            completion: completeAction
        )
    }
    
    func failed(error: NSError) {
        interestButton.enabled = true
        println("TaskDelegate failed: \(error.debugDescription)")
    }
}
