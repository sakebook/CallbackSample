# CallbackSample
Callback sample of Swift

`Protocol`と`Closure`と`NSNotification`を使ったコールバックの実装のサンプルです。

## Protocol
```Task.swift

protocol TaskDelegate {
    func complete(result: AnyObject)
    func failed(error: NSError)
}

final class Task {

    var delegate: TaskDelegate?

	...
	func someTask() {
		...
		someTaskResult(someResult, error: error)
	}

	...
	func someTaskResult(result: AnyObject, error: NSerror) {
		if error == nil {
			self.delegate?.complete(result)
		} else {
			self.delegate?.failed(error)
		}
	}
}

```

```SomeViewController.swift
final class SomeViewController: UIViewController {
	...
	func viewDidLoad() {
		super.viewDidload()
		let task = Task()
		task.delegate = self
		task.someTask()
	}
	...
}

// MARK: - TaskDelegate
extension SomeViewController.swift: TaskDelegate {
	func complete(result: AnyObject) {
		// 処理
	}

	func failed(error: NSError) {
		// 処理
	}
}
```

## Closure

```ClosureAlert.swift
final class ClosureAlert {

    class func showAlert(parentViewController: UIViewController, title: String, message: String, completion: ((Bool) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)

        let yesAction = UIAlertAction(title: "見る", style: UIAlertActionStyle.Default, handler: {
            (action:UIAlertAction!) -> Void in
            // 引数にメソッドが使われてれば実行する
            if let completion = completion {
                // yesなのでtrue
                completion(true)
            }
        })

        let noAction = UIAlertAction(title: "見ない", style: UIAlertActionStyle.Default, handler: {
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
```

```SomeViewController.swift
final class SomeViewController: UIViewController {
	...
	func someMethod(){

        // クリック時に呼ばれるメソッドを定義
        let completeAction: (Bool) -> Void = {
            (isPositive) -> Void in
            if isPositive {
				// okの処理
            } else {
				// ngの処理
            }
        }

        // 実行するのはアラート選択時なのでcompleteActionに`()`はつけない。
        ClosureAlert.showAlert(self, title: "最新の記事", message: "注目です！",
            completion: completeAction
        )
	}
```

## NSNotification

```SomeViewController.swift
final class SomeViewController.swift: UIViewController {

	...
    override func viewDidLoad() {
        super.viewDidLoad()
        // バックグラウンドから復帰した際のObserver
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "comeback:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

	...
	internal func comeback(notification: NSNotification) {
    }
	...
}

```

詳しい説明は[ブログ](http://sakebook.hatenablog.com/entry/2015/08/12/133756)に。
