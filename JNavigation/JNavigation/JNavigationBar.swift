//
//  JNavigationBar.swift
//  JNavigation
//
//  Created by J HD on 16/7/25.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

public class JNavigationItem: UIView {
    
    public init(customView: UIView){
        super.init(frame: CGRect(origin: CGPointZero, size: customView.bounds.size))
        addSubview(customView)
    }
    
    public convenience init(image: UIImage?, style: UIBarButtonItemStyle, target: AnyObject?, action: Selector){
        let button = UIButton(frame: CGRectMake(0,0,44,44))
        button.setImage(image, forState: .Normal)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        self.init(customView: button)
    }
    
    public convenience init(title: String?, target: AnyObject?, action: Selector){
        let width: CGFloat
        if let str = title{
            let rect = (str as NSString).boundingRectWithSize(CGSizeMake(0, 44), options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName: UIFont.systemFontSize()], context: nil)
            width = rect.width
        }
        else{
            width = 44
        }
        let button = UIButton(frame: CGRectMake(0, 0, width + 8, 44))
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        button.setTitle(title, forState: .Normal)
        self.init(customView: button)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public class JNavigationBar: UIView {
    
    init() {
        let width = UIScreen.mainScreen().bounds.width
        super.init(frame: CGRectMake(0, 0, width, 64))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func addSubview(view: UIView) {
        super.addSubview(view)
        sendSubviewToBack(view)
    }
    
    ///used to be leftBarButtonItems
    func setLeftItems(items: JNavigationItem...){
        var x: CGFloat = 16.0
        for item in items{
            //TODO: 判断left center right位置
            item.frame = CGRect(origin: CGPointMake(x, 20), size: item.bounds.size)
            addSubview(item)
            x += item.bounds.width
        }
    }
    
    ///user to be rightBarButtonItems
    func setRightItem(items: JNavigationItem...){
        
    }
    
}

func creatNavigationBar() -> JNavigationBar{
    let bar = JNavigationBar()
    bar.backgroundColor = UIColor.redColor()
    return bar
}