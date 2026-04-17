Pod::Spec.new do |s|
  s.name             = 'iOS26Legacy'
  s.version          = '0.1.0'
  s.summary          = 'UIKit compatibility pod for iOS 26 behavior changes in UIScrollView, UINavigationBar, and UITabBar.'

  s.description      = <<-DESC
iOS26Legacy adapts UIKit behavior changes introduced in iOS 26 via Objective-C method swizzling.

It includes:
- UIScrollView compatibility (disables scroll-edge visual effect).
- UINavigationBar compatibility (disables new bar button background-sharing behavior).
- UITabBar compatibility (disables liquid-glass related view/gesture and restores hidesBottomBarWhenPushed transition behavior with a delegate proxy).

Subspecs:
- base (main switch, `+[iOS26Legacy enable]`)
- UIScrollView
- UINavigationBar
- UITabBar

By default, all subspecs are installed. Non-base subspecs depend on RSSwizzle.
                       DESC

  s.homepage         = 'https://github.com/liuzhe1117/iOS26Legacy'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuzhe1117' => 'liuzhe1117@gmail.com' }
  s.source           = { :git => 'https://github.com/liuzhe1117/iOS26Legacy.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }

  # 不指定 subspec 时安装全部模块
  s.default_subspecs = 'base', 'UIScrollView', 'UINavigationBar', 'UITabBar'

  s.subspec 'base' do |ss|
    ss.source_files = 'sources/base/**/*.{h,m}'
    ss.public_header_files = 'sources/base/**/*.h'
  end

  s.subspec 'UIScrollView' do |ss|
    ss.source_files = 'sources/UIScrollView/**/*.{h,m}'
    ss.public_header_files = 'sources/UIScrollView/**/*.h'
    ss.dependency 'iOS26Legacy/base'
    ss.dependency 'RSSwizzle', '~> 0.1.0'
  end

  s.subspec 'UINavigationBar' do |ss|
    ss.source_files = 'sources/UINavigationBar/**/*.{h,m}'
    ss.public_header_files = 'sources/UINavigationBar/**/*.h'
    ss.dependency 'iOS26Legacy/base'
    ss.dependency 'RSSwizzle', '~> 0.1.0'
  end

  s.subspec 'UITabBar' do |ss|
    ss.source_files = 'sources/UITabBar/**/*.{h,m}'
    ss.public_header_files = 'sources/UITabBar/**/*.h'
    ss.dependency 'iOS26Legacy/base'
    ss.dependency 'RSSwizzle', '~> 0.1.0'
  end
end
