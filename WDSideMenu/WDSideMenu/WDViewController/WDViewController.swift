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

private enum SideMenuSide {
    case LeftMenu
    case RightMenu
}

private enum SideMenuRelativePosition {
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
    
    private var mainViewIsTapped:Bool = false
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var edgeScreenGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    private var sideMenuVisible:Bool = false
    private var originX = 0.0
    private var originY = 0.0
    private var originalSideHorizontalConstraint = 0.0
    private var originalSideVerticalConstraint = 0.0
    private var mainContentViewController:UIViewController?
    private var sideViewController:UIViewController?
    private var sideView:UIView?
    private var mainView:UIView?
    private var sideMenuHorizontalOffset: NSLayoutConstraint!
    private var sideMenuVerticalOffset: NSLayoutConstraint!
    private var menuSide:SideMenuSide = .LeftMenu
    private var sideMenuRelativePosition:SideMenuRelativePosition = .StickedToMainView
    var animationInProgress = false
    
    open var addShadowToTopView:Bool = true
    open var sideMenuType:SideMenuType = .LeftMenuStickedToMainView
    open var panGestureEnabled:Bool = true
    open var sizeMenuWidth:CGFloat = Constants.SCREEN_WIDTH * 0.67
    open var mainContentDelegate:WDSideMenuDelegate! = nil
    open var sideMenuDelegate:WDSideMenuDelegate! = nil
    open var resizeMainContentView:Bool = false
    open var scaleFactor:CGFloat = 1.0
    
    open func setupParameters()
    {
        
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let sideViewDefined = self.sideView
        {
            sideViewDefined.isHidden = false
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let sideView = self.sideView
        {
            mainViewIsTapped = !sideView.frame.contains(gestureRecognizer.location(in:self.view))
        }
        if (gestureRecognizer == self.tapGestureRecognizer || otherGestureRecognizer == self.tapGestureRecognizer) && mainViewIsTapped && sideMenuVisible && resizeMainContentView
        {
            let panGestureIsOneOfThem = gestureRecognizer == self.panGestureRecognizer || otherGestureRecognizer == self.panGestureRecognizer
            if mainViewIsTapped && !panGestureIsOneOfThem
            {
                handleTap(self.tapGestureRecognizer!)
            }
            return false
        }
        return true
    }
    
    final private  func setDefaultParameters()
    {
        addShadowToTopView = true
        resizeMainContentView = false
        sizeMenuWidth = Constants.SCREEN_WIDTH * 0.67
        scaleFactor = (Constants.SCREEN_WIDTH - sizeMenuWidth)/Constants.SCREEN_WIDTH
    }
    
    open func getMainViewController() -> UIViewController?
    {
        return nil
    }
    
    open func getSideMenuViewController() -> UIViewController?
    {
        return nil
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setDefaultParameters()
        self.setupParameters()
        self.handleParameters()
        self.setupContent()
    }
    
    final private func handleParameters()
    {
        switch sideMenuType {
        case .LeftMenuAboveMainView:
            menuSide = .LeftMenu
            sideMenuRelativePosition = .AboveMainView
        case .LeftMenuBelowMainView:
            menuSide = .LeftMenu
            sideMenuRelativePosition = .BelowMainView
        case .LeftMenuStickedToMainView:
            menuSide = .LeftMenu
            sideMenuRelativePosition = .StickedToMainView
        case .RightMenuAboveMainView:
            menuSide = .RightMenu
            sideMenuRelativePosition = .AboveMainView
        case .RightMenuBelowMainView:
            menuSide = .RightMenu
            sideMenuRelativePosition = .BelowMainView
        case .RightMenuStickedToMainView:
            menuSide = .RightMenu
            sideMenuRelativePosition = .StickedToMainView
        }
    }
    
    final private  func setupContent()
    {
        switch sideMenuRelativePosition
        {
        case .BelowMainView:
            self.addSideMenu()
            self.addMainContent()
            if let mainViewDefined = self.mainView
            {
                if addShadowToTopView
                {
                    mainViewDefined.layer.shadowColor = UIColor.black.cgColor
                    mainViewDefined.layer.shadowRadius = 5
                    mainViewDefined.layer.shadowOpacity = 1.0
                    mainViewDefined.layer.masksToBounds = false
                }
            }
        case .AboveMainView:
            self.addMainContent()
            self.addSideMenu()
            if let sideViewDefined = self.sideView
            {
                if addShadowToTopView
                {
                    sideViewDefined.layer.shadowColor = UIColor.black.cgColor
                    sideViewDefined.layer.shadowRadius = 5
                    sideViewDefined.layer.shadowOpacity = 1.0
                    sideViewDefined.layer.masksToBounds = false
                }
                sideViewDefined.isHidden = true
            }
        case .StickedToMainView:
            self.addMainContent()
            self.addSideMenu()
        }
        self.setupPanGesture()
        self.setupTapGesture()
        self.setupEdgeScreenGesture()
    }
    
    final private func setupPanGesture()
    {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGestureRecognizer?.delegate = self
        self.view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    final private func setupEdgeScreenGesture()
    {
        edgeScreenGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdge))
        if menuSide == .LeftMenu
        {
            edgeScreenGestureRecognizer?.edges = .left
        }
        else
        {
            edgeScreenGestureRecognizer?.edges = .right
        }
        edgeScreenGestureRecognizer?.delegate = self
        self.view.addGestureRecognizer(edgeScreenGestureRecognizer!)
    }
    
    final private func setupTapGesture()
    {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer?.delegate = self
        tapGestureRecognizer?.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    @objc final private func handleTap(_ gestureRecognizer: UITapGestureRecognizer)
    {
        if self.sideMenuVisible && mainViewIsTapped
        {
            self.toggleSideMenu()
        }
    }
    
    @objc final private func handleScreenEdge(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer)
    {
        if !panGestureEnabled
        {
            return
        }
        if let sideMenuHorizontalOffset = self.sideMenuHorizontalOffset, let sideMenuVerticalOffset = self.sideMenuVerticalOffset {
            let location = gestureRecognizer.location(in: self.view)
            switch gestureRecognizer.state {
            case .began:
                originX = Double(location.x)
                originY = Double(location.y)
                originalSideHorizontalConstraint = Double(sideMenuHorizontalOffset.constant)
                originalSideVerticalConstraint = Double(sideMenuVerticalOffset.constant)
            case .changed:
                switch menuSide
                {
                case .LeftMenu:
                    sideMenuHorizontalOffset.constant = max(min(sizeMenuWidth, CGFloat(originalSideHorizontalConstraint) + location.x - CGFloat(originX)),0.0)
                case .RightMenu:
                    sideMenuHorizontalOffset.constant = -max(min(sizeMenuWidth, CGFloat(-originalSideHorizontalConstraint) + CGFloat(originX) - location.x),0.0)
                }
                self.transformMainContentView()
                self.view.layoutIfNeeded()
            case .ended:
                var show:Bool = false
                switch menuSide
                {
                case .LeftMenu:
                    if CGFloat(originalSideHorizontalConstraint) + location.x - CGFloat(originX) < sizeMenuWidth * 0.5
                    {
                        sideMenuHorizontalOffset.constant = 0.0
                    }
                    else
                    {
                        sideMenuHorizontalOffset.constant = sizeMenuWidth
                        show = true
                    }
                case .RightMenu:
                    if CGFloat(-originalSideHorizontalConstraint) + CGFloat(originX) - location.x < sizeMenuWidth * 0.5
                    {
                        sideMenuHorizontalOffset.constant = 0.0
                    }
                    else
                    {
                        sideMenuHorizontalOffset.constant = -sizeMenuWidth
                        show = true
                    }
                }
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                    self.transformMainContentView()
                }, completion: { finished in
                    if finished
                    {
                        if let sideMenuDelegate = self.sideMenuDelegate, let mainContentDelegate = self.mainContentDelegate
                        {
                            if show
                            {
                                if !self.sideMenuVisible
                                {
                                    mainContentDelegate.sideViewDidShow!()
                                    sideMenuDelegate.sideViewDidShow!()
                                }
                            }
                            else
                            {
                                if self.sideMenuVisible
                                {
                                    sideMenuDelegate.sideViewDidHide!()
                                    mainContentDelegate.sideViewDidHide!()
                                }
                            }
                        }
                        self.sideMenuVisible = show
                        self.mainView?.isUserInteractionEnabled = !self.sideMenuVisible
                    }
                })
            default:
                print("Do nothing")
            }
        }
        
    }
    
    @objc final private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if !panGestureEnabled || !self.sideMenuVisible || (mainViewIsTapped && sideMenuRelativePosition == .AboveMainView)
        {
            if sideMenuVisible
            {
                self.toggleSideMenu()
            }
            return
        }
        if let sideMenuHorizontalOffset = self.sideMenuHorizontalOffset, let sideMenuVerticalOffset = self.sideMenuVerticalOffset {
            let location = gestureRecognizer.location(in: self.view)
            switch gestureRecognizer.state {
            case .began:
                originX = Double(location.x)
                originY = Double(location.y)
                originalSideHorizontalConstraint = Double(sideMenuHorizontalOffset.constant)
                originalSideVerticalConstraint = Double(sideMenuVerticalOffset.constant)
            case .changed:
                switch menuSide
                {
                case .LeftMenu:
                    sideMenuHorizontalOffset.constant = max(min(sizeMenuWidth, CGFloat(originalSideHorizontalConstraint) + location.x - CGFloat(originX)),0.0)
                case .RightMenu:
                    sideMenuHorizontalOffset.constant = -max(min(sizeMenuWidth, CGFloat(-originalSideHorizontalConstraint) + CGFloat(originX) - location.x),0.0)
                }
                self.transformMainContentView()
                self.view.layoutIfNeeded()
            case .ended:
                var show:Bool = false
                switch menuSide
                {
                case .LeftMenu:
                    if CGFloat(originalSideHorizontalConstraint) + location.x - CGFloat(originX) < sizeMenuWidth * 0.5
                    {
                        sideMenuHorizontalOffset.constant = 0.0
                    }
                    else
                    {
                        sideMenuHorizontalOffset.constant = sizeMenuWidth
                        show = true
                    }
                case .RightMenu:
                    if CGFloat(-originalSideHorizontalConstraint) + CGFloat(originX) - location.x < sizeMenuWidth * 0.5
                    {
                        sideMenuHorizontalOffset.constant = 0.0
                    }
                    else
                    {
                        sideMenuHorizontalOffset.constant = -sizeMenuWidth
                        show = true
                    }
                }
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                    self.transformMainContentView()
                }, completion: { finished in
                    if finished
                    {
                        if let sideMenuDelegate = self.sideMenuDelegate, let mainContentDelegate = self.mainContentDelegate
                        {
                            if show
                            {
                                if !self.sideMenuVisible
                                {
                                    mainContentDelegate.sideViewDidShow!()
                                    sideMenuDelegate.sideViewDidShow!()
                                }
                            }
                            else
                            {
                                if self.sideMenuVisible
                                {
                                    sideMenuDelegate.sideViewDidHide!()
                                    mainContentDelegate.sideViewDidHide!()
                                }
                            }
                        }
                        self.sideMenuVisible = show
                        self.mainView?.isUserInteractionEnabled = !self.sideMenuVisible
                    }
                })
            default:
                print("Do nothing")
            }
        }
    }
    
    final private  func addMainContent()
    {
        self.mainContentViewController = self.getMainViewController()
        if let controller = self.mainContentViewController
        {
            addChildViewController(controller)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(controller.view)
            self.mainView = controller.view
            
            view.addConstraint(NSLayoutConstraint(item: self.mainView!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: self.mainView!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0))
            switch sideMenuRelativePosition
            {
            case .StickedToMainView, .BelowMainView:
                switch menuSide {
                case .LeftMenu:
                    self.sideMenuVerticalOffset = NSLayoutConstraint(item: self.mainView!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
                case .RightMenu:
                    self.sideMenuVerticalOffset = NSLayoutConstraint(item: self.mainView!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
                }
                self.sideMenuHorizontalOffset = NSLayoutConstraint(item: self.mainView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
                view.addConstraint(self.sideMenuHorizontalOffset)
                view.addConstraint(self.sideMenuVerticalOffset)
            case .AboveMainView:
                view.addConstraint(NSLayoutConstraint(item: self.mainView!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
                view.addConstraint(NSLayoutConstraint(item: self.mainView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
            }
            
            controller.didMove(toParentViewController: self)
        }
    }
    
    final private  func addSideMenu()
    {
        self.sideViewController = self.getSideMenuViewController()
        if let controller = self.sideViewController
        {
            addChildViewController(controller)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(controller.view)
            self.sideView = controller.view
            view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: sizeMenuWidth))
            switch sideMenuRelativePosition
            {
            case .StickedToMainView:
                switch menuSide
                {
                case .LeftMenu:
                    view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .trailing, relatedBy: .equal, toItem: self.mainView, attribute: .leading, multiplier: 1, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
                case .RightMenu:
                    view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .leading, relatedBy: .equal, toItem: self.mainView, attribute: .trailing, multiplier: 1, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
                }
            case .AboveMainView:
                view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0))
                switch menuSide
                {
                case .LeftMenu:
                    self.sideMenuHorizontalOffset = NSLayoutConstraint(item: self.sideView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
                    view.addConstraint(self.sideMenuHorizontalOffset)
                    self.sideMenuVerticalOffset = NSLayoutConstraint(item: self.sideView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
                    view.addConstraint(self.sideMenuVerticalOffset)
                case .RightMenu:
                    self.sideMenuHorizontalOffset = NSLayoutConstraint(item: self.sideView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
                    view.addConstraint(self.sideMenuHorizontalOffset)
                    self.sideMenuVerticalOffset = NSLayoutConstraint(item: self.sideView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
                    view.addConstraint(self.sideMenuVerticalOffset)
                }
            case .BelowMainView:
                switch menuSide {
                case .LeftMenu:
                    view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
                case .RightMenu:
                    view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
                }
                view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
                view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
            }
            controller.didMove(toParentViewController: self)
        }
        
    }
    
    final private func transformMainContentView()
    {
        if !resizeMainContentView
        {
            return
        }
        if let mainContentView = self.mainView
        {
            var currentScaleFactor:CGFloat = 1.0
            var translationFactor:CGFloat = 0.0
            var t = CGAffineTransform.identity
            switch menuSide
            {
            case .LeftMenu:
                currentScaleFactor = 1.0 - fabs(self.sideMenuHorizontalOffset.constant)/self.sizeMenuWidth * scaleFactor
                translationFactor = (1.0 - currentScaleFactor) * Constants.SCREEN_WIDTH * 0.5
                t = t.translatedBy(x: -translationFactor, y: 0)
            case .RightMenu:
                currentScaleFactor = 1.0 - fabs(self.sideMenuHorizontalOffset.constant)/self.sizeMenuWidth * scaleFactor
                translationFactor = (1.0 - currentScaleFactor) * Constants.SCREEN_WIDTH * 0.5
                t = t.translatedBy(x: translationFactor, y: 0)
            }
            
            t = t.scaledBy(x: currentScaleFactor, y: currentScaleFactor)
            mainContentView.transform = t
        }
    }
    
    public final func showSideMenu()
    {
        switch menuSide
        {
            case .LeftMenu:
                self.sideMenuHorizontalOffset.constant = sizeMenuWidth
            case .RightMenu:
                self.sideMenuHorizontalOffset.constant = -sizeMenuWidth
        }
        self.animateSideMenu()
    }
    
    public final func hideSideMenu()
    {
        if let sideLeftOffset = self.sideMenuHorizontalOffset
        {
            sideLeftOffset.constant = 0
        }
        if let sideTopOffset = self.sideMenuVerticalOffset
        {
            sideTopOffset.constant = 0
        }
        self.animateSideMenu()
    }
    
    public final func toggleSideMenu()
    {
        if !self.sideMenuVisible
        {
            self.showSideMenu()
        }
        else
        {
            self.hideSideMenu()
        }
        
    }
    
    final func animateSideMenu()
    {
        if !animationInProgress
        {
            animationInProgress = true
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
                self.transformMainContentView()
            }, completion: { finished in
                self.animationInProgress = false
                if finished
                {
                    if let sideMenuDelegate = self.sideMenuDelegate, let mainContentDelegate = self.mainContentDelegate
                    {
                        if !self.sideMenuVisible
                        {
                            mainContentDelegate.sideViewDidShow!()
                            sideMenuDelegate.sideViewDidShow!()
                        }
                        else
                        {
                            sideMenuDelegate.sideViewDidHide!()
                            mainContentDelegate.sideViewDidHide!()
                        }
                    }
                    switch self.menuSide
                    {
                    case .LeftMenu:
                        self.sideMenuVisible = self.sideMenuHorizontalOffset.constant != 0
                    case .RightMenu:
                        self.sideMenuVisible = self.sideMenuHorizontalOffset.constant != 0
                    }
                    self.mainView?.isUserInteractionEnabled = !self.sideMenuVisible
                }
            })
        }
    }
    
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
