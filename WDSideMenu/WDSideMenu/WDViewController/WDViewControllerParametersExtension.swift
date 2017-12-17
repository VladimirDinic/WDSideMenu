//
//  WDViewControllerParametersExtension.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 7/15/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

extension WDViewController
{
    final func setParameters()
    {
        self.setDefaultParameters()
        self.setupParameters()
        self.handleParameters()
    }
    
    final private func setDefaultParameters()
    {
        addShadowToTopView = true
        resizeMainContentView = false
        sizeMenuWidth = Constants.SCREEN_WIDTH * 0.67
        scaleFactor = (Constants.SCREEN_WIDTH - sizeMenuWidth)/Constants.SCREEN_WIDTH
    }
    
    final private func handleParameters()
    {
        switch sideMenuType
        {
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
}
