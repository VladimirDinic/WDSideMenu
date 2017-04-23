//
//  MyWDViewController.swift
//  Dictionary
//
//  Created by Vladimir Dinic on 2/16/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class MyWDViewController: WDViewController, SideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ControlManager.sharedInstance.sideMenuDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupParameters() {
        resizeMainContentView = resizeMainContentViewConfig
        sideMenuType = menuTypeConfig
        scaleFactor = scaleFactorConfig
        sizeMenuWidth = sizeMenuWidthConfig
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
    
    func showMeSideMenu()
    {
        self.showSideMenu()
    }
    
    func hideMeSideMenu()
    {
        self.hideSideMenu()
    }
    
    func toggleMeSideMenu() {
        self.toggleSideMenu()
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
