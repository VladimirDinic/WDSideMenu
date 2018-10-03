//
//  SampleViewController.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/19/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {

    @IBInspectable var headerTitle:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupNavigation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigation()
    {
        self.navigationItem.title = headerTitle
        self.navigationItem.hidesBackButton = true
        var barButton:UIBarButtonItem? = nil
        if (self.navigationController?.viewControllers.count)! > 1
        {
            barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"), style: .plain, target: self, action: #selector(showMenuOrGoBack))
        }
        else
        {
            barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menuIcon"), style: .plain, target: self, action: #selector(showMenuOrGoBack))
        }
        barButton?.tintColor = UIColor(red: 0.0, green: 105.0/255.0, blue: 105.0/255.0, alpha: 1.0)
        switch menuTypeConfig
        {
        case .LeftMenuAboveMainView, .LeftMenuBelowMainView, .LeftMenuStickedToMainView:
            self.navigationItem.leftBarButtonItem = barButton
        case .RightMenuAboveMainView, .RightMenuBelowMainView, .RightMenuStickedToMainView:
            self.navigationItem.rightBarButtonItem = barButton
        }
    }
    
    @objc func showMenuOrGoBack()
    {
        if let navigationController = self.navigationController as? MyNavigationController
        {
            navigationController.showMenuOrGoBack()
        }
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
