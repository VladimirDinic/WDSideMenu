//
//  SideViewController.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/18/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class SideViewController: UIViewController, WDSideMenuDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var tableViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.tableViewWidthConstraint.constant = sizeMenuWidthConfig
        /*switch menuTypeConfig
        {
        case .LeftMenuStickedToMainView, .LeftMenuAboveMainView, .RightMenuBelowMainView:
            self.tableViewTrailingConstraint.constant = 0
        case .RightMenuStickedToMainView, .RightMenuAboveMainView, .LeftMenuBelowMainView:
            self.tableViewTrailingConstraint.constant = Constants.SCREEN_WIDTH - sizeMenuWidthConfig
        }
        self.view.layoutIfNeeded()*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! MenuCell
        cell.tintColor = UIColor(red: 0.0, green: 105.0/255.0, blue: 105.0/255.0, alpha: 1.0)
        cell.backgroundColor = UIColor.clear
        switch indexPath.row
        {
        case 0:
            cell.menuCellImage?.image = #imageLiteral(resourceName: "userIcon")
            cell.menuCellLabel?.text = "My profile"
        case 1:
            cell.menuCellImage?.image = #imageLiteral(resourceName: "mapIcon")
            cell.menuCellLabel?.text = "Show map"
        case 2:
            cell.menuCellImage?.image = #imageLiteral(resourceName: "termsAndConditionsIcon")
            cell.menuCellLabel?.text = "Terms and Conditions"
        default:
            print("Do nothing")
        }
        return cell
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.sideMenuTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.IS_IPAD ? 100.0 : 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageToOpenDict:[String:String] = ["PageToOpen":"Page\(indexPath.row)"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectItem"), object: nil, userInfo: pageToOpenDict)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func sideViewDidShow() {
        
    }
    
    func sideViewDidHide() {
        
    }

}
