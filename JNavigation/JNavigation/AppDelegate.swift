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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = TestViewController()
        vc.navigationStyle = JNavigationStyle.default(color: UIColor.green)
        window?.rootViewController = JNavigationController(rootViewController: vc)
        
        window?.makeKeyAndVisible()
        
        
        return true
    }


}

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "title"
        
        view.backgroundColor = UIColor.white
        
        let button = UIButton(frame: CGRect(x: 0,y: 0,width: 100,height: 50))
        button.backgroundColor = UIColor.red
        button.setTitle("push", for: UIControlState())
        button.addTarget(self, action: #selector(TestViewController.push), for: .touchUpInside)
        view.addSubview(button)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(TestViewController.pop))
        
    }
    
    func pop(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func push(){
        let vc = TestViewController()
        vc.navigationStyle = JNavigationStyle.default(color: UIColor.green)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
