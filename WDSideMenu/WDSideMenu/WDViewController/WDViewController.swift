//
//  WDViewController.swift
//  Dictionary
//
//  Created by Vladimir Dinic on 2/16/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

private class Constants: NSObject {
    static let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.size.height
}

@objc protocol WDSideMenuDelegate{
    @objc optional func sideViewDidShow()
    @objc optional func sideViewDidHide()
}

enum SideMenuSide {
    case LeftMenu
    case RightMenu
}

class WDViewController: UIViewController, UIGestureRecognizerDelegate {

    private var mainViewIsTapped:Bool = false
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var sideMenuVisible:Bool = false
    private var originX = 0.0
    private var originalSideConstraint = 0.0
    private var mainContentViewController:UIViewController?
    private var sideViewController:UIViewController?
    private var sideView:UIView?
    private var mainView:UIView?
    private var sideMenuOffset: NSLayoutConstraint!
    
    var sizeMenuWidth:CGFloat = Constants.SCREEN_WIDTH * 0.67
    
    var mainContentDelegate:WDSideMenuDelegate! = nil
    var sideMenuDelegate:WDSideMenuDelegate! = nil
    
    var menuSide:SideMenuSide = .LeftMenu
    
    var resizeMainContentView:Bool = false
    var scaleFactor:CGFloat = 1.0
    
    func setupParameters()
    {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name(rawValue: "ShowMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name(rawValue: "SelectItem"), object: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let mainView = self.mainView
        {
            mainViewIsTapped = mainView.frame.contains(gestureRecognizer.location(in:self.view))
            if (gestureRecognizer == self.tapGestureRecognizer || otherGestureRecognizer == self.tapGestureRecognizer) && mainViewIsTapped && sideMenuVisible && resizeMainContentView
            {
                let panGestureIsOneOfThem = gestureRecognizer == self.panGestureRecognizer || otherGestureRecognizer == self.panGestureRecognizer
                if mainViewIsTapped && !panGestureIsOneOfThem
                {
                    handleTap(self.tapGestureRecognizer!)
                }
                return false
            }
        }
        return true
    }
    
    final private  func setDefaultParameters()
    {
        resizeMainContentView = false
        menuSide = .LeftMenu
        sizeMenuWidth = Constants.SCREEN_WIDTH * 0.67
        scaleFactor = (Constants.SCREEN_WIDTH - sizeMenuWidth)/Constants.SCREEN_WIDTH
    }
    
    func getMainViewController() -> UIViewController?
    {
        return nil
    }
    
    func getSideMenuViewController() -> UIViewController?
    {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setDefaultParameters()
        self.setupParameters()
        
        self.setupContent()
    }
    
    final private  func setupContent()
    {
        self.addMainContent()
        self.addSideMenu()
        self.setupPanGesture()
        self.setupTapGesture()
    }
    
    final private func setupPanGesture()
    {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGestureRecognizer?.delegate = self
        self.view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    final private func setupTapGesture()
    {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer?.delegate = self
        tapGestureRecognizer?.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    @objc final private func handleTap(_ gestureRecognizer: UITapGestureRecognizer)
    {
        if self.sideMenuVisible && self.resizeMainContentView && mainViewIsTapped
        {
            self.toggleSideMenu()
        }
    }
    
    
    @objc final private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: self.view)
        switch gestureRecognizer.state {
        case .began:
            originX = Double(location.x)
            originalSideConstraint = Double(self.sideMenuOffset.constant)
        case .changed:
            if self.menuSide == SideMenuSide.LeftMenu
            {
                self.sideMenuOffset.constant = max(min(sizeMenuWidth, CGFloat(originalSideConstraint) + location.x - CGFloat(originX)),0.0)
            }
            else
            {
                self.sideMenuOffset.constant = -max(min(sizeMenuWidth, CGFloat(-originalSideConstraint) + CGFloat(originX) - location.x),0.0)
            }
            self.transformMainContentView()
            self.view.layoutIfNeeded()
        case .ended:
            var show:Bool = false
            if self.menuSide == SideMenuSide.LeftMenu
            {
                if CGFloat(originalSideConstraint) + location.x - CGFloat(originX) < sizeMenuWidth * 0.5
                {
                    self.sideMenuOffset.constant = 0.0
                }
                else
                {
                    self.sideMenuOffset.constant = sizeMenuWidth
                    show = true
                }
            }
            else
            {
                if CGFloat(-originalSideConstraint) + CGFloat(originX) - location.x < sizeMenuWidth * 0.5
                {
                    self.sideMenuOffset.constant = 0.0
                }
                else
                {
                    self.sideMenuOffset.constant = -sizeMenuWidth
                    show = true
                }
            }
            UIView.animate(withDuration: 0.3, animations: { 
                self.view.layoutIfNeeded()
                self.transformMainContentView()
            }, completion: { finished in
                if finished
                {
                    if let sideMenuDelegate = self.sideMenuDelegate, let mainContentDelegate = self.mainContentDelegate
                    {
                        if show
                        {
                            if !self.sideMenuVisible
                            {
                                mainContentDelegate.sideViewDidShow!()
                                sideMenuDelegate.sideViewDidShow!()
                            }
                        }
                        else
                        {
                            if self.sideMenuVisible
                            {
                                sideMenuDelegate.sideViewDidHide!()
                                mainContentDelegate.sideViewDidHide!()
                            }
                        }
                    }
                    self.sideMenuVisible = show
                }
            })
        default:
            print("Do nothing")
        }
    }
    
    final private  func addMainContent()
    {
        self.mainContentViewController = self.getMainViewController()
        if let controller = self.mainContentViewController
        {
            addChildViewController(controller)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(controller.view)
            self.mainView = controller.view
            
            let width = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
            let height = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            self.sideMenuOffset = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
            
            view.addConstraint(width)
            view.addConstraint(height)
            view.addConstraint(self.sideMenuOffset)
            view.addConstraint(centerY)
            
            controller.didMove(toParentViewController: self)
        }
    }
    
    final private  func addSideMenu()
    {
        self.sideViewController = self.getSideMenuViewController()
        if let controller = self.sideViewController
        {
            addChildViewController(controller)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(controller.view)
            self.sideView = controller.view
            
            let width = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
            let bottomAllign = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            let topAllign = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            var positionRelativeToMainView: NSLayoutConstraint
            if self.menuSide == SideMenuSide.LeftMenu
            {
                positionRelativeToMainView = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
            }
            else
            {
                positionRelativeToMainView = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
            }
            
            view.addConstraint(width)
            view.addConstraint(bottomAllign)
            view.addConstraint(topAllign)
            view.addConstraint(positionRelativeToMainView)
            
            controller.didMove(toParentViewController: self)
        }
        
    }
    
    final private func transformMainContentView()
    {
        if !resizeMainContentView
        {
            return
        }
        if let mainContentView = self.mainView
        {
            let currentScaleFactor = 1.0 - fabs(self.sideMenuOffset.constant)/self.sizeMenuWidth * scaleFactor
            let translationFactor = (1.0 - currentScaleFactor) * Constants.SCREEN_WIDTH * 0.5
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: menuSide == .LeftMenu ? -translationFactor : translationFactor, y: 0)
            t = t.scaledBy(x: currentScaleFactor, y: currentScaleFactor)
            mainContentView.transform = t
        }
    }
    
    final func toggleSideMenu()
    {
        if !self.sideMenuVisible
        {
            self.sideMenuOffset.constant = self.menuSide == .LeftMenu ? sizeMenuWidth : -sizeMenuWidth
        }
        else
        {
            self.sideMenuOffset.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.transformMainContentView()
        }, completion: { finished in
            if finished
            {
                if let sideMenuDelegate = self.sideMenuDelegate, let mainContentDelegate = self.mainContentDelegate
                {
                    if !self.sideMenuVisible
                    {
                        mainContentDelegate.sideViewDidShow!()
                        sideMenuDelegate.sideViewDidShow!()
                    }
                    else
                    {
                        sideMenuDelegate.sideViewDidHide!()
                        mainContentDelegate.sideViewDidHide!()
                    }
                }
                self.sideMenuVisible = self.sideMenuOffset.constant != 0
                self.mainView?.isUserInteractionEnabled = !(self.resizeMainContentView && self.sideMenuVisible)
            }
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


/*
 
 🎉  Congrats
 
 🚀  WDSideMenu (0.0.1) successfully published
 📅  February 19th, 06:13
 🌎  https://cocoapods.org/pods/WDSideMenu
 👍  Tell your friends!
 
 */
