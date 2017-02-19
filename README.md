# WDSideMenu
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WDSideMenu.svg)](https://img.shields.io/cocoapods/v/WDSideMenu.svg)
[![License](https://img.shields.io/cocoapods/l/WDSideMenu.svg?style=flat)](http://cocoapods.org/pods/WDSideMenu)
[![Platform](https://img.shields.io/cocoapods/p/WDSideMenu.svg?style=flat)](http://cocoapods.org/pods/WDSideMenu)

Simple, customizable and effective side menu for iOS apps

![GitHub Logo](/docs/images/WDSideMenu.gif)

# Features:
* Two types of side menu:
 * Classic side menu
 * Side menu with resizable central (main) content
* Two ways to show / hide side menu:
 * Pan gesture 
 * Embedded method
* Side menu can be on:
 * Left side or
 * Right side
* Other customizable parameters:
 * In order to define main view or side view, you just have to create appropriate UIViewControllers, and use them as parameters for setting up side menu.
 * Side menu width
 * Main content scale / resize factor
* Delegate methods which will be called when side menu did show or did hide

#Instalation:
##Manual:
Download this project and add WDViewController.swift file to your project

##CocoaPods:
```Ruby
pod 'WDSideMenu'
```
#Usage
1. After including WDViewController.swift file in your project (via CocoaPods or manual), create a UIViewController which will subclass WDViewController, and this UIViewController will be holder for your main content and side menu.
2. Define UIViewControllers which will be used as main content or side view.
3. Define parameters if you don't like default settings (side menu width, main content scale factor,...)

##Example of usage
```Swift
import UIKit

class MyHomeViewController: WDViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupParameters() {
        resizeMainContentView = true
        menuSide = .LeftMenu
        sizeMenuWidth = UIScreen.main.bounds.size.width * 0.7
        scaleFactor = 0.5
    }

    override func getMainViewController() -> UIViewController? {
        let navigation:MyNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController") as! MyNavigationController
        self.mainContentDelegate = navigation
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController")
    }
    
    override func getSideMenuViewController() -> UIViewController? {
        let sideMenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideViewController") as! SideViewController
        self.sideMenuDelegate = sideMenuViewController
        return sideMenuViewController
    }
}
```

#Note:
Documentation is still in preparation and the code will be updated regularly
<br>If you find any bug, please report it, and I will try to fix it ASAP.
