Pod::Spec.new do |s|
  s.name             = 'ReactiveCleanKit'
  s.version          = '0.1.1'
  s.summary          = 'Lib Rx DI'
  s.description      = "Lib for building reactive apps, based on RxSwift, Swinject"

  s.homepage         = 'https://github.com/wolvesstudio/RCKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Oleksii Moiseenko' => 'oleksiimoiseenko@gmail.com' }
  s.source           = { :git => 'https://github.com/techpro-studio/RCKit.git', :tag => s.version }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/**/*.swift'
  s.swift_version = '5.0'
  
  s.frameworks = 'UIKit', 'UserNotifications'
  s.dependency 'Swinject'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
end
