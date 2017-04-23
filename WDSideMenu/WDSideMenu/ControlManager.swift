//
//  ControlManager.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 4/23/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

protocol SideMenuDelegate
{
    func showMeSideMenu()
    func hideMeSideMenu()
    func toggleMeSideMenu()
}


class ControlManager: NSObject {
    
    static let sharedInstance = ControlManager()
    
    var sideMenuDelegate:SideMenuDelegate?
    
    override init() {
        super.init()
        
    }

}
