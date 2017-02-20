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
}

@objc public protocol WDSideMenuDelegate{
    @objc optional func sideViewDidShow()
    @objc optional func sideViewDidHide()
}

public enum SideMenuSide {
    case LeftMenu
    case RightMenu
    case BottomMenu
}

public enum SideMenuRelativePosition {
    case StickedToMainView
    case AboveMainView
}

open class WDViewController: UIViewController, UIGestureRecognizerDelegate {

    private var mainViewIsTapped:Bool = false
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var sideMenuVisible:Bool = false
    private var originX = 0.0
    private var originY = 0.0
    private var originalSideLeftConstraint = 0.0
    private var originalSideTopConstraint = 0.0
    private var mainContentViewController:UIViewController?
    private var sideViewController:UIViewController?
    private var sideView:UIView?
    private var mainView:UIView?
    private var sideMenuLeftOffset: NSLayoutConstraint!
    private var sideMenuTopOffset: NSLayoutConstraint!
    
    open var panGestureEnabled:Bool = true
    open var sideMenuRelativePosition:SideMenuRelativePosition = .StickedToMainView
    open var sizeMenuWidth:CGFloat = Constants.SCREEN_WIDTH * 0.67
    open var sizeMenuHeight:CGFloat = Constants.SCREEN_HEIGHT * 0.67
    open var mainContentDelegate:WDSideMenuDelegate! = nil
    open var sideMenuDelegate:WDSideMenuDelegate! = nil
    open var menuSide:SideMenuSide = .LeftMenu
    open var resizeMainContentView:Bool = false
    open var scaleFactor:CGFloat = 1.0
    
    open func setupParameters()
    {
        
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name(rawValue: "ShowMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name(rawValue: "SelectItem"), object: nil)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let mainView = self.mainView
        {
            mainViewIsTapped = mainView.frame.contains(gestureRecognizer.location(in:self.view))
            if (gestureRecognizer == self.tapGestureRecognizer || otherGestureRecognizer == self.tapGestureRecognizer) && mainViewIsTapped && sideMenuVisible && resizeMainContentView
            {
                let panGestureIsOneOfThem = gestureRecognizer == self.panGestureRecognizer || otherGestureRecognizer == self.panGestureRecognizer
                if mainViewIsTapped && !panGestureIsOneOfThem
                {
                    handleTap(self.tapGestureRecognizer!)
                }
                return false
            }
        }
        return true
    }
    
    final private  func setDefaultParameters()
    {
        resizeMainContentView = false
        menuSide = .LeftMenu
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
        
        self.setupContent()
    }
    
    final private  func setupContent()
    {
        self.addMainContent()
        self.addSideMenu()
        self.setupPanGesture()
        self.setupTapGesture()
    }
    
    final private func setupPanGesture()
    {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGestureRecognizer?.delegate = self
        self.view.addGestureRecognizer(panGestureRecognizer!)
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
        if self.sideMenuVisible && self.resizeMainContentView && mainViewIsTapped
        {
            self.toggleSideMenu()
        }
    }
    
    
    @objc final private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if !panGestureEnabled
        {
            return
        }
        if let sideMenuLeftOffset = self.sideMenuLeftOffset, let sideMenuTopOffset = self.sideMenuTopOffset {
            let location = gestureRecognizer.location(in: self.view)
            switch gestureRecognizer.state {
            case .began:
                originX = Double(location.x)
                originY = Double(location.y)
                originalSideLeftConstraint = Double(sideMenuLeftOffset.constant)
                originalSideTopConstraint = Double(sideMenuTopOffset.constant)
            case .changed:
                switch menuSide
                {
                case .LeftMenu:
                    sideMenuLeftOffset.constant = max(min(sizeMenuWidth, CGFloat(originalSideLeftConstraint) + location.x - CGFloat(originX)),0.0)
                case .RightMenu:
                    sideMenuLeftOffset.constant = -max(min(sizeMenuWidth, CGFloat(-originalSideLeftConstraint) + CGFloat(originX) - location.x),0.0)
                case .BottomMenu:
                    switch sideMenuRelativePosition
                    {
                    case .StickedToMainView:
                        sideMenuTopOffset.constant = max(min(sizeMenuHeight, CGFloat(originalSideTopConstraint) + location.y - CGFloat(originY)),0.0)
                    case .AboveMainView:
                        if location.y < CGFloat(originY)
                        {
                            sideMenuTopOffset.constant = -max(min(sizeMenuHeight, CGFloat(originalSideTopConstraint) + CGFloat(originY) - location.y),0.0)
                        }
                        else
                        {
                            sideMenuTopOffset.constant = min(sizeMenuHeight,CGFloat(originalSideTopConstraint) + location.y - CGFloat(originY))
                        }
                        
                    }
                }
                self.transformMainContentView()
                self.view.layoutIfNeeded()
            case .ended:
                var show:Bool = false
                switch menuSide
                {
                case .LeftMenu:
                    if CGFloat(originalSideLeftConstraint) + location.x - CGFloat(originX) < sizeMenuWidth * 0.5
                    {
                        sideMenuLeftOffset.constant = 0.0
                    }
                    else
                    {
                        sideMenuLeftOffset.constant = sizeMenuWidth
                        show = true
                    }
                case .RightMenu:
                    if CGFloat(-originalSideLeftConstraint) + CGFloat(originX) - location.x < sizeMenuWidth * 0.5
                    {
                        sideMenuLeftOffset.constant = 0.0
                    }
                    else
                    {
                        sideMenuLeftOffset.constant = -sizeMenuWidth
                        show = true
                    }
                case .BottomMenu:
                    switch sideMenuRelativePosition
                    {
                    case .StickedToMainView:
                        if CGFloat(originalSideTopConstraint) + location.y - CGFloat(originY) < sizeMenuHeight * 0.5
                        {
                            sideMenuTopOffset.constant = 0.0
                        }
                        else
                        {
                            sideMenuTopOffset.constant = sizeMenuHeight
                            show = true
                        }
                    case .AboveMainView:
                        if fabs(CGFloat(originalSideTopConstraint) + location.y - CGFloat(originY)) < sizeMenuHeight * 0.5
                        {
                            sideMenuTopOffset.constant = 0.0
                        }
                        else
                        {
                            sideMenuTopOffset.constant = -sizeMenuHeight
                            show = true
                        }
                    }
                    

                }

                UIView.animate(withDuration: 0.3, animations: {
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
            
            let width = NSLayoutConstraint(item: self.mainView!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
            let height = NSLayoutConstraint(item: self.mainView!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
            view.addConstraint(width)
            view.addConstraint(height)
            switch sideMenuRelativePosition
            {
            case .StickedToMainView:
                switch menuSide {
                case .LeftMenu:
                    self.sideMenuTopOffset = NSLayoutConstraint(item: self.mainView!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
                case .RightMenu:
                    self.sideMenuTopOffset = NSLayoutConstraint(item: self.mainView!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
                case .BottomMenu:
                    self.sideMenuTopOffset = NSLayoutConstraint(item: self.mainView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
                }
                self.sideMenuLeftOffset = NSLayoutConstraint(item: self.mainView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
                view.addConstraint(self.sideMenuLeftOffset)
                view.addConstraint(self.sideMenuTopOffset)
            case .AboveMainView:
                let centerX = NSLayoutConstraint(item: self.mainView!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
                let bottom = NSLayoutConstraint(item: self.mainView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
                view.addConstraint(centerX)
                view.addConstraint(bottom)
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
            
            let width = NSLayoutConstraint(item: self.sideView!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
            var bottomAllign:NSLayoutConstraint
            var topAllign:NSLayoutConstraint
            var positionRelativeToMainView: NSLayoutConstraint
            switch sideMenuRelativePosition
            {
            case .StickedToMainView:
                switch menuSide
                {
                case .LeftMenu:
                    positionRelativeToMainView = NSLayoutConstraint(item: self.sideView!, attribute: .trailing, relatedBy: .equal, toItem: self.mainView, attribute: .leading, multiplier: 1, constant: 0)
                    topAllign = NSLayoutConstraint(item: self.sideView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
                    bottomAllign = NSLayoutConstraint(item: self.sideView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
                case .RightMenu:
                    positionRelativeToMainView = NSLayoutConstraint(item: self.sideView!, attribute: .leading, relatedBy: .equal, toItem: self.mainView, attribute: .trailing, multiplier: 1, constant: 0)
                    bottomAllign = NSLayoutConstraint(item: self.sideView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
                    topAllign = NSLayoutConstraint(item: self.sideView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
                case .BottomMenu:
                    positionRelativeToMainView = NSLayoutConstraint(item: self.sideView!, attribute: .centerX, relatedBy: .equal, toItem: self.mainView, attribute: .centerX, multiplier: 1, constant: 0)
                    bottomAllign = NSLayoutConstraint(item: self.sideView!, attribute: .top, relatedBy: .equal, toItem: self.mainView, attribute: .bottom, multiplier: 1, constant: 0)
                    topAllign = NSLayoutConstraint(item: self.sideView!, attribute: .height, relatedBy: .equal, toItem: self.mainView, attribute: .height, multiplier: 1, constant: 0)
                }
                view.addConstraint(bottomAllign)
                view.addConstraint(topAllign)
                view.addConstraint(positionRelativeToMainView)
            case .AboveMainView:
                let height = NSLayoutConstraint(item: self.sideView!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
                switch menuSide
                {
                case .LeftMenu:
                    self.sideMenuLeftOffset = NSLayoutConstraint(item: self.sideView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
                    view.addConstraint(self.sideMenuLeftOffset)
                    view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
                case .RightMenu:
                    self.sideMenuLeftOffset = NSLayoutConstraint(item: self.sideView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
                    view.addConstraint(self.sideMenuLeftOffset)
                    view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
                case .BottomMenu:
                    self.sideMenuTopOffset = NSLayoutConstraint(item: self.sideView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
                    view.addConstraint(self.sideMenuTopOffset)
                    self.sideMenuLeftOffset = NSLayoutConstraint(item: self.sideView!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
                    view.addConstraint(self.sideMenuLeftOffset)
                }
                view.addConstraint(height)
            }
            view.addConstraint(width)
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
                currentScaleFactor = 1.0 - fabs(self.sideMenuLeftOffset.constant)/self.sizeMenuWidth * scaleFactor
                translationFactor = (1.0 - currentScaleFactor) * Constants.SCREEN_WIDTH * 0.5
                t = t.translatedBy(x: -translationFactor, y: 0)
            case .RightMenu:
                currentScaleFactor = 1.0 - fabs(self.sideMenuLeftOffset.constant)/self.sizeMenuWidth * scaleFactor
                translationFactor = (1.0 - currentScaleFactor) * Constants.SCREEN_WIDTH * 0.5
                t = t.translatedBy(x: translationFactor, y: 0)
            case .BottomMenu:
                currentScaleFactor = 1.0 - fabs(self.sideMenuTopOffset.constant)/self.sizeMenuHeight * scaleFactor
                translationFactor = (1.0 - currentScaleFactor) * Constants.SCREEN_HEIGHT * 0.5
                t = t.translatedBy(x: 0, y: -translationFactor)
            }
            
            t = t.scaledBy(x: currentScaleFactor, y: currentScaleFactor)
            mainContentView.transform = t
        }
    }
    
    final func toggleSideMenu()
    {
        if !self.sideMenuVisible
        {
            switch menuSide
            {
            case .LeftMenu:
                self.sideMenuLeftOffset.constant = sizeMenuWidth
            case .RightMenu:
                self.sideMenuLeftOffset.constant = -sizeMenuWidth
            case .BottomMenu:
                self.sideMenuTopOffset.constant = -sizeMenuHeight
            }
        }
        else
        {
            self.sideMenuLeftOffset.constant = 0
            self.sideMenuTopOffset.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.transformMainContentView()
        }, completion: { finished in
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
                    self.sideMenuVisible = self.sideMenuLeftOffset.constant != 0
                case .RightMenu:
                    self.sideMenuVisible = self.sideMenuLeftOffset.constant != 0
                case .BottomMenu:
                    self.sideMenuVisible = self.sideMenuTopOffset.constant != 0
                }
                self.mainView?.isUserInteractionEnabled = !(self.resizeMainContentView && self.sideMenuVisible)
            }
        })
    }


    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
