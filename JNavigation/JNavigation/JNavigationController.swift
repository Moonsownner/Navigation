//
//  JNavigationController.swift
//  JNavigation
//
//  Created by J HD on 16/7/25.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

open class NavigationController: UIViewController {
    
//    public var
    
}

extension UIViewController{
    
    var jNavigationBar: JNavigationBar?{
        for v in view.subviews{
            if v is JNavigationBar{
                return v as? JNavigationBar
            }
        }
        return nil
    }
    
    func setNavitaionBar(){
        let v = view.copy() as! UIView
        
    }
    
}

extension UINavigationController{
    
}

//class CustomNaviController: UIViewController{
//    
//    var navigationBar: UIView
//    var contentView: UIView
//    
//}
