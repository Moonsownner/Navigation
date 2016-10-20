//
//  JNavigationBar.swift
//  JNavigation
//
//  Created by J HD on 16/7/25.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

open class JNavigationItem: UIView {
    
    public init(customView: UIView){
        super.init(frame: CGRect(origin: CGPoint.zero, size: customView.bounds.size))
        addSubview(customView)
    }
    
    public convenience init(image: UIImage?, style: UIBarButtonItemStyle, target: AnyObject?, action: Selector){
        let button = UIButton(frame: CGRect(x: 0,y: 0,width: 44,height: 44))
        button.setImage(image, for: UIControlState())
        button.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: button)
    }
    
    public convenience init(title: String?, target: AnyObject?, action: Selector){
        let width: CGFloat
        if let str = title{
            let rect = (str as NSString).boundingRect(with: CGSize(width: 0, height: 44), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName: UIFont.systemFontSize], context: nil)
            width = rect.width
        }
        else{
            width = 44
        }
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: width + 8, height: 44))
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitle(title, for: UIControlState())
        self.init(customView: button)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

open class JNavigationBar: UIView {
    
    init() {
        let width = UIScreen.main.bounds.width
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 64))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        sendSubview(toBack: view)
    }
    
    ///used to be leftBarButtonItems
    func setLeftItems(_ items: JNavigationItem...){
        var x: CGFloat = 16.0
        for item in items{
            //TODO: 判断left center right位置
            item.frame = CGRect(origin: CGPoint(x: x, y: 20), size: item.bounds.size)
            addSubview(item)
            x += item.bounds.width
        }
    }
    
    ///user to be rightBarButtonItems
    func setRightItem(_ items: JNavigationItem...){
        
    }
    
}

func creatNavigationBar() -> JNavigationBar{
    let bar = JNavigationBar()
    bar.backgroundColor = UIColor.red
    return bar
}
