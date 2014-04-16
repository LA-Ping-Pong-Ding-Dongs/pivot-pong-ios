platform :ios, '7.0'
xcodeproj 'PivotPong/PivotPong.xcodeproj'

def global
  pod 'KSDeferred'
  pod 'Blindside', podspec: 'https://raw.githubusercontent.com/jbsf/blindside/master/Blindside.podspec'
  pod 'PivotalCoreKit'
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

