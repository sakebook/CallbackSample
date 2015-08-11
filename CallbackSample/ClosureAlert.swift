//
//  ClosureAlert.swift
//  CallbackSample
//
//  Created by 酒本 伸也 on 2015/07/18.
//  Copyright (c) 2015年 酒本 伸也. All rights reserved.
//

import Foundation
import UIKit

final class ClosureAlert {
    
    class func showAlert(parentViewController: UIViewController, title: String, message: String, positiveLabel: String, negativeLabel: String, completion: ((Bool) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let yesAction = UIAlertAction(title: positiveLabel, style: UIAlertActionStyle.Default, handler: {
            (action:UIAlertAction!) -> Void in
            // 引数にメソッドが使われてれば実行する
            if let completion = completion {
                // yesなのでtrue
                completion(true)
            }
        })
        
        let noAction = UIAlertAction(title: negativeLabel, style: UIAlertActionStyle.Default, handler: {
            (action:UIAlertAction!) -> Void in
            // 引数にメソッドが使われてれば実行する
            if let completion = completion {
                // noなのでfalse
                completion(false)
            }
        })
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        parentViewController.presentViewController(alert, animated: true, completion: nil)
    }
}