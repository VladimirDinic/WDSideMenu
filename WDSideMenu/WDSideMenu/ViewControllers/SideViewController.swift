//
//  SideViewController.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/18/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class SideViewController: UIViewController, WDSideMenuDelegate, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath)
        cell.textLabel?.textColor = UIColor(red: 0.7, green: 0.0, blue: 0.0, alpha: 1.0)
        cell.textLabel?.text = "Page\(indexPath.row)"
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.width * 0.1
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
