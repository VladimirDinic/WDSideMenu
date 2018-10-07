//
//  WDViewControllerViewsExtension.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 7/15/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

extension WDViewController
{
    final func setupContent()
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
    
    final private  func addMainContent()
    {
        self.mainContentViewController = self.getMainViewController()
        if let controller = self.mainContentViewController
        {
            addChild(controller)
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
            
            controller.didMove(toParent: self)
        }
    }
    
    final private  func addSideMenu()
    {
        self.sideViewController = self.getSideMenuViewController()
        if let controller = self.sideViewController
        {
            addChild(controller)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(controller.view)
            self.sideView = controller.view
            if sideViewHasFullWidth {
                view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0.0))
            } else {
                view.addConstraint(NSLayoutConstraint(item: self.sideView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: sizeMenuWidth))
            }
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
            controller.didMove(toParent: self)
        }
        
    }
}
