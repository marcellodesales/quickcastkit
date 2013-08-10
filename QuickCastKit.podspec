Pod::Spec.new do |s|
  s.name         = "QuickCastKit"
  s.version      = "0.0.1"
  s.summary      = "Objective-C HTTP client for integrating with the QuickCast API."
  s.homepage     = "https://github.com/quickcast/quickcastkit"
  s.license      = 'MIT'
  s.author       = { "Andy Smart" => "andy@andysmart.org" }
  s.source       = { :git => "https://github.com/quickcast/quickcastkit", :tag => "0.0.1" }
  s.platform     = :ios, '6.0'
  s.source_files = 'QuickCastKit/**/*.{h,m}'
  s.frameworks   = 'MobileCoreServices', 'SystemConfiguration'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 1.3.1'
end
