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
    let interestButton = UIButton(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width , UIScreen.mainScreen().bounds.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        fetchArticleWihtTagName("Swift")
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "comebackWebView:", name: NOTIFICATION_COMEBACK_WEB_VIEW, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
        showRecomendAlert()
    }
    
    internal func comebackWebView(sender: AnyObject) {
        println("comebackWebView: method")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFICATION_COMEBACK_WEB_VIEW, object: nil)
        showRecomendAlert()
    }
}


// MARK: - ViewController
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
    
    func showRecomendAlert() {
        if let article = openedArticle {
            openedArticle = nil
            ClosureAlert.showAlert(self, title: "記事はどうだった？", message: "\(article.tags[article.number])も興味ある？",
                positiveLabel: "ある",
                negativeLabel: "ない",
                completion: {(isPositive) -> Void in
                    if isPositive {
                        println("ほかにも興味があるらしい")
                        let interest = Interest(article: article)
                        self.chengeButtonDesign(interest)
                        self.fetchArticleWihtTagName(interest.name)
                    } else {
                        println("ほかには興味がないらしい")
                        self.chengeButtonDesign(Interest(type: .Swift))
                    }
                }
            )
        }
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
                    // バックグラウンドから復帰した際のObserver
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: "comeback:", name: UIApplicationWillEnterForegroundNotification, object: nil)
                    UIApplication.sharedApplication().openURL(url)
                }
            } else {
                println("Safariを開かない")
                self.openedArticle = qiitaArticle
                let controller = WebViewController.getController(self.storyboard!, article: qiitaArticle)
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
        
        // 実行するのはアラート選択時なのでcompleteActionに`()`はつけない。
        ClosureAlert.showAlert(self,
            title: "最新の記事",
            message: qiitaArticle.title,
            positiveLabel: "Safariで見る",
            negativeLabel: "アプリで見る",
            completion: completeAction
        )
    }
    
    func failed(error: NSError) {
        interestButton.enabled = true
        println("TaskDelegate failed: \(error.debugDescription)")
    }
}
