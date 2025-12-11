Pod::Spec.new do |spec|
  spec.name         = "AdPieX-SDK"
  spec.version      = "1.0.0"
  spec.summary      = "AdPieX Ads SDK."
  spec.description  = "The AdPieX SDK allows developers to easily incorporate banner, interstitial and native ads. It will benefit developers a lot."
  spec.homepage     = "https://docs.adpiex.com/adpiex"
  spec.license = {
    :type => 'commercial',
    :text => 'Neptune Company. All rights Reserved.'
  }
  spec.author       = "Neptune Company"
  spec.platform     = :ios, "12.0"
  spec.ios.deployment_target = "12.0"
  spec.source       = { :git => "https://github.com/adxcorp/adpiex-ios-sdk.git", :tag => spec.version.to_s }
  spec.ios.vendored_frameworks = "frmAdPieX/AdPieXFramework.xcframework"
  spec.frameworks = "AdSupport", "CoreTelephony", "SystemConfiguration"
  spec.weak_frameworks = "WebKit"
  spec.xcconfig  =  { "OTHER_LDFLAGS" => "-ObjC", "LIBRARY_SEARCH_PATHS" => "$(SRCROOT)/Pods/AdPieX-SDK" }
end