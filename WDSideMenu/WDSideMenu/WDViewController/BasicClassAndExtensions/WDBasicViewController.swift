//
//  WDBasicViewController.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/25/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

@objc public protocol WDSideMenuDelegate{
    @objc optional func sideViewDidShow()
    @objc optional func sideViewDidHide()
}

open class WDBasicViewController: UIViewController {

    internal var mainViewIsTapped:Bool = false
    internal var panGestureRecognizer: UIPanGestureRecognizer?
    internal var tapGestureRecognizer: UITapGestureRecognizer?
    internal var sideMenuVisible:Bool = false
    internal var originX = 0.0
    internal var originY = 0.0
    internal var originalSideHorizontalConstraint = 0.0
    internal var originalSideVerticalConstraint = 0.0
    internal var mainContentViewController:UIViewController?
    internal var sideViewController:UIViewController?
    internal var sideView:UIView?
    internal var mainView:UIView?
    internal var sideMenuHorizontalOffset: NSLayoutConstraint!
    internal var sideMenuVerticalOffset: NSLayoutConstraint!
    internal var menuSide:SideMenuSide = .LeftMenu
    internal var sideMenuRelativePosition:SideMenuRelativePosition = .StickedToMainView
    
    open var addShadowToTopView:Bool = true
    open var sideMenuType:SideMenuType = .LeftMenuStickedToMainView
    open var panGestureEnabled:Bool = true
    open var sizeMenuWidth:CGFloat = Constants.SCREEN_WIDTH * 0.67
    open var mainContentDelegate:WDSideMenuDelegate! = nil
    open var sideMenuDelegate:WDSideMenuDelegate! = nil
    open var resizeMainContentView:Bool = false
    open var scaleFactor:CGFloat = 1.0
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
