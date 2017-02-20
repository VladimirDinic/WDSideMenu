//
//  MyWDViewController.swift
//  Dictionary
//
//  Created by Vladimir Dinic on 2/16/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class MyWDViewController: WDViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupParameters() {
        resizeMainContentView = resizeMainContentViewConfig
        menuSide = menuSideConfig
        scaleFactor = 0.5
        
        switch menuSide
        {
        case .LeftMenu:
            sizeMenuWidth = sizeMenuWidthConfig
        case .RightMenu:
            sizeMenuWidth = sizeMenuWidthConfig
        case .BottomMenu:
            sizeMenuHeight = sizeMenuHeightConfig
        }
        sideMenuRelativePosition = sideMenuRelativePositionConfig
    }

    override func getMainViewController() -> UIViewController? {
        let navigation:MyNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController") as! MyNavigationController
        self.mainContentDelegate = navigation
        navigation.wdSideView = self
        return navigation
    }
    
    override func getSideMenuViewController() -> UIViewController? {
        let sideMenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideViewController") as! SideViewController
        self.sideMenuDelegate = sideMenuViewController
        return sideMenuViewController
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
