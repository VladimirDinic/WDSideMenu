//
//  MyNavigationController.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/19/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController, WDSideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openPage(notification:Notification)
    {
        let pageToOpen = notification.userInfo?["PageToOpen"]
        self.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: pageToOpen as! String), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(openPage), name: NSNotification.Name(rawValue: "SelectItem"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func showMenuOrGoBack()
    {
        if self.viewControllers.count == 1
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowMenu"), object: nil)
        }
        else
        {
            let _ = self.popViewController(animated: true)
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
    
    func sideViewDidShow() {
        
    }
    
    func sideViewDidHide() {
        
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
