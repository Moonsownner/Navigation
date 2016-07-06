//
//  ViewController.swift
//  JNavigation
//
//  Created by J HD on 16/7/5.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

struct JNavigationConfig {
    
    static var navigationStyleKey = "JNavigationStyle"
    static var defaultColor = UIColor.blueColor()
    
}

class JNavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        switch rootViewController.navigationStyle {
        case .Custom:
            super.init(rootViewController: rootViewController)
        default:
            super.init(rootViewController: WrapViewController(childVC: rootViewController))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        setNavigationBarHidden(true, animated: false)
        
    }
    
    var j_viewControllers: [UIViewController]{
        get{
            var vcs = [UIViewController]()
            for vc in self.viewControllers{
                if vc is WrapViewController{
                    vcs.append((vc as! WrapViewController).childVC)
                }
                else{
                    vcs.append(vc)
                }
            }
            return vcs
        }
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        switch viewController.navigationStyle {
        case .Custom:
            super.pushViewController(viewController, animated: animated)
        default:
            if viewController is WrapViewController{
                super.pushViewController(viewController, animated: animated)
            }
            else{
                super.pushViewController(WrapViewController(childVC: viewController), animated: animated)
            }
        }
    }
    
    override func setViewControllers(viewControllers: [UIViewController], animated: Bool) {
        let vcs: [UIViewController] = viewControllers.map{
            
            guard !($0 is WrapViewController) else{
                return $0
            }
            
            switch $0.navigationStyle{
            case .Custom:
                return $0
            default:
                return WrapViewController(childVC: $0)
            }
            
        }
        super.setViewControllers(vcs, animated: animated)
    }
    
}

extension JNavigationController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if viewController === navigationController.viewControllers.first{
            interactivePopGestureRecognizer?.enabled = false
        }
        else{
            interactivePopGestureRecognizer?.enabled = true
            interactivePopGestureRecognizer!.delegate = self
        }
    }
    
}

enum JNavigationStyle {
    
    case Custom
    case Default(color: UIColor)
    
    var rawValue: Int {
        switch self {
        case .Custom:
            return 0
        case .Default(color: _):
            return 1
        }
    }
    
    init(rawValue: Int){
        if rawValue == 1{
            self = .Default(color: JNavigationConfig.defaultColor)
        }
        else{
            self = .Custom
        }
    }
    
}

extension UIViewController {
    
    var navigationStyle: JNavigationStyle{
        set{
            objc_setAssociatedObject(self, &JNavigationConfig.navigationStyleKey, newValue.rawValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            if let i = objc_getAssociatedObject(self, &JNavigationConfig.navigationStyleKey) as? Int{
                return JNavigationStyle(rawValue: i)
            }
            else{
                return JNavigationStyle.Default(color: JNavigationConfig.defaultColor)
            }
        }
    }
    
}

class WrapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let statusBarBackView = UIView()
    
    let navigationBar = UINavigationBar()
    
    var childVC: UIViewController
    
    init(childVC: UIViewController) {
        self.childVC = childVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesBottomBarWhenPushed = childVC.hidesBottomBarWhenPushed
        
        navigationBar.pushNavigationItem(childVC.navigationItem, animated: true)
        
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        view.addSubview(statusBarBackView)
        view.addSubview(navigationBar)
        
        addChildViewController(childVC)
        view.addSubview(childVC.view)
        childVC.didMoveToParentViewController(self)
        
        switch childVC.navigationStyle {
        case .Default(color: let color):
            setBarColor(color)
        default:
            break
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        statusBarBackView.frame = CGRectMake(0, 0, view.bounds.width, 20)
        navigationBar.frame = CGRectMake(0, 20, view.bounds.width, 44)
        
        if !hidesBottomBarWhenPushed && tabBarController != nil{
            childVC.view.frame = CGRectMake(0, 64, view.bounds.width, view.bounds.height - 64 - 49)
        }
        else{
            childVC.view.frame = CGRectMake(0, 64, view.bounds.width, view.bounds.height - 64)
        }
        
    }
    
    ///设置bar颜色
    func setBarColor(color: UIColor){
        statusBarBackView.backgroundColor = color
        navigationBar.backgroundColor = color
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return childVC.prefersStatusBarHidden()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return childVC.preferredStatusBarStyle()
    }
    
}