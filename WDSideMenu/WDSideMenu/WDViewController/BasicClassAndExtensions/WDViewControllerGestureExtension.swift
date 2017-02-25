//
//  WDViewControllerExtension.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/25/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import Foundation
import UIKit

extension WDViewController
{
    @objc final internal func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
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
    
    final internal func setupPanGesture()
    {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGestureRecognizer?.delegate = self
        self.view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    final internal func setupTapGesture()
    {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer?.delegate = self
        tapGestureRecognizer?.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    final internal func handleTap(_ gestureRecognizer: UITapGestureRecognizer)
    {
        if self.sideMenuVisible && self.resizeMainContentView && mainViewIsTapped
        {
            self.toggleSideMenu()
        }
    }
}
