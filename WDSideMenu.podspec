Pod::Spec.new do |s|

s.platform = :ios
s.name             = "WDSideMenu"
s.version          = "0.2.1"
s.summary          = "WDSideMenu is a simple, powerful, customizable side menu for iOS apps."

s.description      = <<-DESC
This fantastic view changes its color gradually makes your app look fantastic!
DESC

s.homepage         = "https://github.com/VladimirDinic/WDSideMenu"
s.license          = { :type => "MIT", :file => "LICENSE" }
s.author           = { "Vladimir Dinic" => "vladimir88dev@gmail.com" }
s.source           = { :git => "https://github.com/VladimirDinic/WDSideMenu.git", :tag => "#{s.version}"}

s.ios.deployment_target = "10.0"
s.source_files = "WDSideMenu/WDSideMenu/WDViewController/WDViewController.swift"

end
