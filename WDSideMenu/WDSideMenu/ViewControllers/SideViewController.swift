//
//  SideViewController.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/18/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class SideViewController: UIViewController, WDSideMenuDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch menuSideConfig
        {
        case .LeftMenu:
            self.tableViewWidthConstraint.constant = sizeMenuWidthConfig
            self.tableViewTrailingConstraint.constant = 0.0
        case .RightMenu:
            self.tableViewWidthConstraint.constant = sizeMenuWidthConfig
            self.tableViewTrailingConstraint.constant = UIScreen.main.bounds.size.width - sizeMenuWidthConfig
        case .BottomMenu:
            self.tableViewWidthConstraint.constant = sizeMenuWidthConfig
            self.tableViewTrailingConstraint.constant = UIScreen.main.bounds.size.width - sizeMenuWidthConfig
        }
        self.view.layoutIfNeeded()
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
        cell.tintColor = UIColor(red: 0.0, green: 0.6, blue: 0.6, alpha: 1.0)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.SCREEN_WIDTH * 0.15
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
