Pod::Spec.new do |s|
  s.name         = "TTBaseUIKit"
  s.version      = "1.3.30"
  s.summary      = "Custom UIKit"
  s.description  = "BaseUIView, BaseUILable, BaseUIButton, BaseUITableView"
  s.homepage     = "https://github.com/tqtuan1201/TTBaseUIKit"
  s.license      = "MIT"
  s.author       = { "Truong Quang Tuan" => "truongquangtuanit@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/tqtuan1201/TTBaseUIKit.git", :tag => "#{s.version}" }
  s.source_files = "TTBaseUIKit/Sources/TTBaseUIKit/**/*.{swift}"
  s.exclude_files = "TTBaseUIKit/Sources/TTBaseUIKit/**/*.plist"
  s.swift_version = '5.0'
  #s.resources = 'TTBaseUIKit/Support/Fonts/*{.ttf}'
  s.resource_bundle = { 'TTBaseUIKit' => ['TTBaseUIKit/Sources/TTBaseUIKit/**/*.{ttf}','TTBaseUIKit/Sources/TTBaseUIKit/**/*.{png}'] }
  s.ios.deployment_target  = '10.0'
  s.frameworks = 'UIKit', 'Foundation'
  
end
