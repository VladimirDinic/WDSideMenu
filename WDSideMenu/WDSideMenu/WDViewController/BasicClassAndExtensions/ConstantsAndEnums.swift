//
//  ConstantsAndEnums.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/25/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import Foundation
import UIKit

public class Constants: NSObject {
    static let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.size.height
    static let IS_IPAD:Bool = UIDevice.current.userInterfaceIdiom == .pad
}

/**
 Private enum type which defines "3D" position of side menu relative to main view
 */
internal enum SideMenuSide {
    case LeftMenu
    case RightMenu
}
/**
 Private enum type which defines "3D" position of side menu relative to main view
 */
internal enum SideMenuRelativePosition {
    case StickedToMainView
    case AboveMainView
    case BelowMainView
}

/**
 Defines type of side menu, i.e. position of side menu relative to main view
 */
public enum SideMenuType
{
    case LeftMenuStickedToMainView
    case LeftMenuAboveMainView
    case LeftMenuBelowMainView
    case RightMenuStickedToMainView
    case RightMenuAboveMainView
    case RightMenuBelowMainView
}
