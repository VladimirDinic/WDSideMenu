# WDSideMenu
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WDSideMenu.svg)](http://cocoapods.org/pods/WDSideMenu)
[![License](https://img.shields.io/cocoapods/l/WDSideMenu.svg?style=flat)](http://cocoapods.org/pods/WDSideMenu)
[![Platform](https://img.shields.io/cocoapods/p/WDSideMenu.svg?style=flat)](http://cocoapods.org/pods/WDSideMenu)

# Features:
* 6 types of side menu:
 * Left menu sticked to main view<br>
 ![GitHub Logo](/Docs/Images/LeftMenuStickedToMainView.gif)
 * Left menu above main view<br>
 ![GitHub Logo](/Docs/Images/LeftMenuAboveMainView.gif)
 * Left menu below main view<br>
 ![GitHub Logo](/Docs/Images/LeftMenuBelowMainView.gif)
 * Right menu sticked to main view<br>
 ![GitHub Logo](/Docs/Images/RIghtMenuStickedToMainView.gif)
 * Right menu above main view<br>
 ![GitHub Logo](/Docs/Images/RIghtMenuAboveSideView.gif)
 * Right menu below main view<br>
 ![GitHub Logo](/Docs/Images/RIghtMenuBelowMainView.gif)
* You can set make your central (main) content resizable  (you can define scale parameter) <br>
 ![GitHub Logo](/Docs/Images/LeftMenuBelowMainViewWithResize.gif)
* Two ways to show / hide side menu:
 * Pan gesture 
 * Embedded method
* Other customizable parameters:
 * In order to define main view or side view, you just have to create appropriate UIViewControllers, set up their layouts, and use them as parameters for setting up side menu.
 * Side menu width
 * Shadow on / off
* Delegate methods which will be called when side menu did show or did hide

# Installation:
## Manual:
Download this project and add WDViewController.swift file to your project

## CocoaPods:
```Ruby
target '<TargetName>' do
    use_frameworks!
    pod 'WDSideMenu', ' ~> 1.0.1'
end
```
# Usage
1. After including WDViewController.swift file in your project (via CocoaPods or manual), create a UIViewController which will subclass WDViewController, and this UIViewController will be holder for your main content and side menu.
2. Define UIViewControllers which will be used as main content or side view.
3. Implement WDSideMenuDelegate in your ViewControllers if you want to use sideViewDidShow() and sideViewDidHide() delegate methods
4. Override setupParameters() method and define parameters if you don't like default settings (side menu width, main content scale factor,...)

## Example of usage
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
        sideMenuType = .LeftMenuBelowMainView
        resizeMainContentView = true
        sizeMenuWidth = UIScreen.main.bounds.size.width * 0.7
        scaleFactor = 0.2
    }

    override func getMainViewController() -> UIViewController? {
        let navigation:MyNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController") as! MyNavigationController
        self.mainContentDelegate = navigation
        return navigation
    }
    
    override func getSideMenuViewController() -> UIViewController? {
        let sideMenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideViewController") as! SideViewController
        self.sideMenuDelegate = sideMenuViewController
        return sideMenuViewController
    }
}
```

# Note:
Documentation is still in preparation and the code will be updated regularly
<br>If you find any bug, please report it, and I will try to fix it ASAP.
