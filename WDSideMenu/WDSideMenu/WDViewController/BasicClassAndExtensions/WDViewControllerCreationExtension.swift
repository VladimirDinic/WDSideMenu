//
//  WDViewControllerCreationExtension.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/25/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import Foundation
import UIKit

extension WDViewController
{
    open func setupParameters()
    {
        
    }
    
    final internal  func addMainContent()
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
    
    final internal func addSideMenu()
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
}
