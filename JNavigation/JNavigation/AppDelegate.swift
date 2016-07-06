//
//  AppDelegate.swift
//  JNavigation
//
//  Created by J HD on 16/7/5.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let vc = TestViewController()
        vc.navigationStyle = JNavigationStyle.Default(color: UIColor.greenColor())
        let a = JNavigationController(rootViewController: vc)
        window?.rootViewController = a
        
        window?.makeKeyAndVisible()
        
        
        return true
    }


}

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "title"
        
        view.backgroundColor = UIColor.whiteColor()
        
        let button = UIButton(frame: CGRectMake(0,0,100,50))
        button.backgroundColor = UIColor.redColor()
        button.setTitle("push", forState: .Normal)
        button.addTarget(self, action: #selector(TestViewController.push), forControlEvents: .TouchUpInside)
        view.addSubview(button)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(TestViewController.pop))
        
    }
    
    func pop(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func push(){
        let vc = TestViewController()
        vc.navigationStyle = JNavigationStyle.Default(color: UIColor.greenColor())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
