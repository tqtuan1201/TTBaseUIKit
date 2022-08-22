Pod::Spec.new do |s|
  s.name         = "TTBaseUIKit"
  s.version      = "1.3.27"
  s.summary      = "Custom UIKit"
  s.description  = "BaseUIView, BaseUILable, BaseUIButton, BaseUITableView"
  s.homepage     = "https://github.com/tqtuan1201/TTBaseUIKit"
  s.license      = "MIT"
  s.author       = { "Truong Quang Tuan" => "truongquangtuanit@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/tqtuan1201/TTBaseUIKit.git", :tag => "#{s.version}" }
  s.source_files = "Sources/TTBaseUIKit/**/*.{swift}"
  s.exclude_files = "Sources/TTBaseUIKit/**/*.plist"
  s.swift_version = '5.0'
  #s.resources = 'TTBaseUIKit/Support/Fonts/*{.ttf}'
  s.resource_bundle = { 'TTBaseUIKit' => ['Sources/TTBaseUIKit/**/*.{ttf}','Sources/TTBaseUIKit/**/*.{png}'] }
  s.ios.deployment_target  = '10.0'
  s.frameworks = 'UIKit', 'Foundation'
  
end
