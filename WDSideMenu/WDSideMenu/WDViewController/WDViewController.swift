//
//  WDViewController.swift
//  Dictionary
//
//  Created by Vladimir Dinic on 2/16/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

public class Constants: NSObject {
    static let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.size.height
    static let IS_IPAD:Bool = UIDevice.current.userInterfaceIdiom == .pad
}

@objc public protocol WDSideMenuDelegate{
    @objc optional func sideViewDidShow()
    @objc optional func sideViewDidHide()
}
 enum SideMenuSide {
    case LeftMenu
    case RightMenu
}
 enum SideMenuRelativePosition {
    case StickedToMainView
    case AboveMainView
    case BelowMainView
}

public enum SideMenuType
{
    case LeftMenuStickedToMainView
    case LeftMenuAboveMainView
    case LeftMenuBelowMainView
    case RightMenuStickedToMainView
    case RightMenuAboveMainView
    case RightMenuBelowMainView
}

open class WDViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var mainViewIsTapped:Bool = false
    var panGestureRecognizer: UIPanGestureRecognizer?
    var tapGestureRecognizer: UITapGestureRecognizer?
    var edgeScreenGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    var sideMenuVisible:Bool = false
    var originX = 0.0
    var originY = 0.0
    var originalSideHorizontalConstraint = 0.0
    var originalSideVerticalConstraint = 0.0
    var mainContentViewController:UIViewController?
    var sideViewController:UIViewController?
    var sideView:UIView?
    var mainView:UIView?
    var sideMenuHorizontalOffset: NSLayoutConstraint!
    var sideMenuVerticalOffset: NSLayoutConstraint!
    var menuSide:SideMenuSide = .LeftMenu
    var sideMenuRelativePosition:SideMenuRelativePosition = .StickedToMainView
    var animationInProgress = false
    
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
        
        self.setParameters()
        self.setupContent()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let sideViewDefined = self.sideView
        {
            sideViewDefined.isHidden = false
        }
    }
    
    open func getMainViewController() -> UIViewController?
    {
        return nil
    }
    
    open func getSideMenuViewController() -> UIViewController?
    {
        return nil
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
