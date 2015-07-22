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
    let NOTIFICATION_COMEBACK_ANDROID = "ComebackAndroid"
    let interestButton = UIButton(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width , UIScreen.mainScreen().bounds.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupButton()
        interestButton.enabled = false
        
        let task = Task()
        task.delegate = self
        task.fetchLatestArticle(getCurrentInterest())
        
        // バックグラウンドから復帰した際のObserver
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "comeback:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
}


extension ViewController {
    internal func fetchCurrentInterest(sender: AnyObject) {
        println("fetchCurrentInterest")
        interestButton.enabled = false
        let task = Task()
        task.delegate = self
        task.fetchLatestArticle(interestButton.titleLabel?.text ?? "Swift")
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
                        self.chengeButtonDesign()
                        let task = Task()
                        task.delegate = self
                        task.fetchLatestArticle(self.getCurrentInterest())
//                        NSNotificationCenter.defaultCenter().addObserver(self, selector: "comebackAndroid:", name: self.NOTIFICATION_COMEBACK_ANDROID, object: nil)
                    } else {
                        println("Androidには興味がないらしい")
                        self.chengeButtonDesign()
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
    func setupButton() {
        interestButton.backgroundColor = UIColor.orangeColor()
        interestButton.setTitle("Swift", forState: .Normal)
        interestButton.addTarget(self, action: "fetchCurrentInterest:", forControlEvents: .TouchUpInside)
        self.view.addSubview(interestButton)
    }
    
    func getCurrentInterest() -> String {
        return interestButton.titleLabel?.text ?? "Swift"
    }
    
    // TODO: 引数にinterestを渡す
    func chengeButtonDesign() {
        interestButton.backgroundColor = UIColor.greenColor()
        interestButton.setTitle("Android", forState: .Normal)
    }
}


// MARK: - TaskDelegate
extension ViewController: TaskDelegate {
    func complete(qiitaArticle: QiitaArticle) {
        interestButton.enabled = true
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
        interestButton.enabled = true
        println("TaskDelegate failed: \(error.debugDescription)")
    }
}
