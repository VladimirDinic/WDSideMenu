//
//  WDViewControllerExtension.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 7/15/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

extension WDViewController
{
    final func setupTapGesture()
    {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer?.delegate = self
        tapGestureRecognizer?.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    final func setupPanGesture()
    {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGestureRecognizer?.delegate = self
        self.view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    final func setupEdgeScreenGesture()
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
        }
        if gestureRecognizer == self.edgeScreenGestureRecognizer || otherGestureRecognizer == self.edgeScreenGestureRecognizer
        {
            return true
        }
        return false
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
            guard
                let mainView = self.mainView,
                mainView.frame.contains(location) else {
                    switch gestureRecognizer.state {
                    case .ended:
                        if panningSideMenuInProgress {
                            endedGesture(location: location)
                        }
                    default:
                        print("Do nothing")
                    }
                    return
            }
            switch gestureRecognizer.state {
            case .began:
                panningSideMenuInProgress = true
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
                endedGesture(location: location)
            default:
                print("Do nothing")
            }
        }
    }
    
    func endedGesture(location:CGPoint) {
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
            self.panningSideMenuInProgress = false
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
    }
}
