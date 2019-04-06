Pod::Spec.new do |s|
  s.name         = "TTBaseUIKit"
  s.version      = "1.0.2"
  s.summary      = "Custom UIKit"
  s.description  = "BaseUIView, BaseUILable, BaseUIButton, BaseUITableView"
  s.homepage     = "https://github.com/tuan123/TTBaseUIKit"
  s.license      = "MIT"
  s.author       = { "Truong Quang Tuan" => "truongquangtuanit@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/tuan123/TTBaseUIKit.git", :tag => "1.0.0" }
  s.source_files = "TTBaseUIKit/**/*"
  s.exclude_files = "TTBaseUIKit/**/*.plist"
  s.swift_version = '5.0'
  s.ios.deployment_target  = '10.0'
  
end


  