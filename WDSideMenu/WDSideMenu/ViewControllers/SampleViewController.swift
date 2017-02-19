//
//  SampleViewController.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/19/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigation()
    {
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
        switch menuSideConfig
        {
        case .LeftMenu:
            self.navigationItem.leftBarButtonItem = barButton
        case .RightMenu:
            self.navigationItem.rightBarButtonItem = barButton
        case .BottomMenu:
            self.navigationItem.leftBarButtonItem = barButton
        }
    }
    
    func showMenuOrGoBack()
    {
        if let navigationController = self.navigationController as! MyNavigationController!
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