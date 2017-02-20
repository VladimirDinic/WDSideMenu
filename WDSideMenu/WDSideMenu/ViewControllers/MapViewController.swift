//
//  MapViewController.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/21/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: SampleViewController {

    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        let disablePanGestureDict = ["DisablePanGesture":true]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DisablePanGesture"), object: nil, userInfo: disablePanGestureDict)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        let disablePanGestureDict = ["DisablePanGesture":false]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DisablePanGesture"), object: nil, userInfo: disablePanGestureDict)
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
