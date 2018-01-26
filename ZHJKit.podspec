Pod::Spec.new do |s|
  s.name = "ZHJKit"
  s.version = "0.0.2"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary = "An iOS development Kit."
  s.homepage = "https://github.com/HuajingZeng/ZHJKit"
  s.author = { "Kevin Zeng" => "503132987@qq.com" }
  s.social_media_url = "http://huajingzeng.com"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/HuajingZeng/ZHJKit.git", :tag => s.version.to_s }
  s.source_files  = "ZHJKit/ZHJKit.h"
  s.public_header_files = "ZHJKit/ZHJKit.h"
  s.requires_arc = true

  s.subspec 'Category' do |ss|
    ss.source_files = 'ZHJKit/Category/*.{h,m}'
    ss.public_header_files = 'ZHJKit/Category/*.h'
    ss.ios.frameworks = 'UIKit'
  end

  s.subspec 'Marco' do |ss|
    ss.source_files = 'ZHJKit/Marco/*.{h,m}'
    ss.public_header_files = 'ZHJKit/Marco/*.h'
    ss.ios.frameworks = 'UIKit'
  end

  s.subspec 'UI' do |ss|
    ss.source_files = 'ZHJKit/UI/*.{h,m}'
    ss.public_header_files = 'ZHJKit/UI/*.h'
    ss.ios.frameworks = 'UIKit'
    ss.dependency 'ZHJKit/Marco', 'ZHJKit/Category', 'ZHJKit/Utility'
  end

  s.subspec 'Utility' do |ss|
    ss.source_files = 'ZHJKit/Utility/*.{h,m}'
    ss.public_header_files = 'ZHJKit/Utility/*.h'
    ss.ios.frameworks = 'UIKit'
    ss.dependency 'ZHJKit/Marco'
  end

end
