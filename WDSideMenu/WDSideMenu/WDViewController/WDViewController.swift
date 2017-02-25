//
//  WDViewController.swift
//  Dictionary
//
//  Created by Vladimir Dinic on 2/16/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

open class WDViewController: WDBasicViewController, UIGestureRecognizerDelegate {
    
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
        addShadowToTopView = true
        resizeMainContentView = false
        sizeMenuWidth = Constants.SCREEN_WIDTH * 0.67
        scaleFactor = (Constants.SCREEN_WIDTH - sizeMenuWidth)/Constants.SCREEN_WIDTH
    }
    
    /**
     Use this method to select UIViewController whose view will be used as view for main content
     */
    open func getMainViewController() -> UIViewController?
    {
        return nil
    }
    
    /**
     Use this method to select UIViewController whose view will be used as side view
     */
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
                mainViewDefined.layer.shadowColor = UIColor.black.cgColor
                mainViewDefined.layer.shadowRadius = 5
                mainViewDefined.layer.shadowOpacity = 1.0
                mainViewDefined.layer.masksToBounds = false
            }
        case .AboveMainView:
            self.addMainContent()
            self.addSideMenu()
            if let sideViewDefined = self.sideView
            {
                sideViewDefined.layer.shadowColor = UIColor.black.cgColor
                sideViewDefined.layer.shadowRadius = 5
                sideViewDefined.layer.shadowOpacity = 1.0
                sideViewDefined.layer.masksToBounds = false
            }
        case .StickedToMainView:
            self.addMainContent()
            self.addSideMenu()
        }
        self.setupPanGesture()
        self.setupTapGesture()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
