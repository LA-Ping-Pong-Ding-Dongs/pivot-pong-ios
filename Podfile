platform :ios, '7.1'
xcodeproj 'PivotPong.xcodeproj'

def global
  pod 'KSDeferred'
  pod 'Blindside', podspec: 'https://raw.githubusercontent.com/jbsf/blindside/master/Blindside.podspec'
  pod 'PivotalCoreKit', :inhibit_warnings => true
end

target :PivotPong do
  global
end

target :Specs do
  pod 'Cedar'
  pod 'PivotalCoreKit/UIKit/SpecHelper/Extensions'
  pod 'PivotalCoreKit/UIKit/SpecHelper/Stubs'
  pod 'PivotalCoreKit/Foundation/SpecHelper/Fakes'
  global
end

