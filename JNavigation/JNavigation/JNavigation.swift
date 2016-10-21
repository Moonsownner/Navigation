//
//  ViewController.swift
//  JNavigation
//
//  Created by J HD on 16/7/5.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

public struct JNavigationConfig {
    
    static var navigationStyleKey = "JNavigationStyle"
    static var defaultColor = UIColor.blue
    
}

open class JNavigationController: UINavigationController {
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        switch rootViewController.navigationStyle {
        case .custom:
            super.init(rootViewController: rootViewController)
        default:
            super.init(rootViewController: WrapViewController(childVC: rootViewController))
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
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
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        switch viewController.navigationStyle {
        case .custom:
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
    
    override open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        let vcs: [UIViewController] = viewControllers.map{
            
            guard !($0 is WrapViewController) else{
                return $0
            }
            
            switch $0.navigationStyle{
            case .custom:
                return $0
            default:
                return WrapViewController(childVC: $0)
            }
            
        }
        super.setViewControllers(vcs, animated: animated)
    }
    
}

extension JNavigationController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController === navigationController.viewControllers.first{
            interactivePopGestureRecognizer?.isEnabled = false
        }
        else{
            interactivePopGestureRecognizer?.isEnabled = true
            interactivePopGestureRecognizer!.delegate = self
        }
    }
    
}

public enum JNavigationStyle {
    
    case `default`(color: UIColor)
    case custom
    
    var rawValue: Int {
        switch self {
        case .default(color: _):
            return 0
        case .custom:
            return 1
       }
    }
    
    init(rawValue: Int){
        if rawValue == 0{
            self = .default(color: JNavigationConfig.defaultColor)
        }
        else{
            self = .custom
        }
    }
    
}

public extension UIViewController {
    
    var navigationStyle: JNavigationStyle{
        set{
            objc_setAssociatedObject(self, &JNavigationConfig.navigationStyleKey, newValue.rawValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            if let i = objc_getAssociatedObject(self, &JNavigationConfig.navigationStyleKey) as? Int{
                return JNavigationStyle(rawValue: i)
            }
            else{
                return JNavigationStyle.default(color: JNavigationConfig.defaultColor)
            }
        }
    }
    
    ///设置bar颜色
    func setBarColor(_ color: UIColor){
        if self is WrapViewController{
            let vc = self as! WrapViewController
            vc.statusBarBackView.backgroundColor = color
            vc.navigationBar.backgroundColor = color
        }
        else{
            if self.parent is WrapViewController{
                let vc = self.parent as! WrapViewController
                vc.statusBarBackView.backgroundColor = color
                vc.navigationBar.backgroundColor = color
            }
        }
    }

}

open class WrapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let statusBarBackView = UIView()
    
    let navigationBar = UINavigationBar()
    
    let childVC: UIViewController
    
    init(childVC: UIViewController) {
        self.childVC = childVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        hidesBottomBarWhenPushed = childVC.hidesBottomBarWhenPushed
        
        navigationBar.pushItem(childVC.navigationItem, animated: true)
        
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        if !self.prefersStatusBarHidden{
            view.addSubview(statusBarBackView)
        }
        view.addSubview(navigationBar)
        
        addChildViewController(childVC)
        view.addSubview(childVC.view)
        childVC.didMove(toParentViewController: self)
        
        switch childVC.navigationStyle {
        case .default(color: let color):
            setBarColor(color)
        default:
            break
        }
        
    }
    
    override open func viewWillLayoutSubviews() {
        
        if !self.prefersStatusBarHidden{
            
            statusBarBackView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 20)
            navigationBar.frame = CGRect(x: 0, y: 20, width: view.bounds.width, height: 44)
            if !hidesBottomBarWhenPushed && tabBarController != nil{
                childVC.view.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64 - 49)
            }
            else{
                childVC.view.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
            }
            
        }
        else{
            
            statusBarBackView.isHidden = true
            navigationBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
            if !hidesBottomBarWhenPushed && tabBarController != nil{
                childVC.view.frame = CGRect(x: 0, y: 44, width: view.bounds.width, height: view.bounds.height - 44 - 49)
            }
            else{
                childVC.view.frame = CGRect(x: 0, y: 44, width: view.bounds.width, height: view.bounds.height - 44)
            }
            
        }
        
        childVC.viewWillLayoutSubviews()
        
    }
    
    override open var prefersStatusBarHidden : Bool {
        return childVC.prefersStatusBarHidden
    }
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return childVC.preferredStatusBarStyle
    }
    
}
