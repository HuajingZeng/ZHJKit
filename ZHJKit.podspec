Pod::Spec.new do |s|
  s.name = "ZHJKit"
  s.version = "0.0.3"
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
  s.frameworks = 'UIKit'

  s.subspec 'Category' do |ss|
    ss.public_header_files = 'ZHJKit/Category/*.h'
    ss.source_files = 'ZHJKit/Category/*.{h,m}'
  end

  s.subspec 'Marco' do |ss|
    ss.public_header_files = 'ZHJKit/Marco/*.h'
    ss.source_files = 'ZHJKit/Marco/*.{h,m}'
  end

  s.subspec 'UI' do |ss|
    ss.dependency 'ZHJKit/Marco'
    ss.dependency 'ZHJKit/Category'
    ss.dependency 'ZHJKit/Utility'
    ss.public_header_files = 'ZHJKit/UI/*.h'
    ss.source_files = 'ZHJKit/UI/*.{h,m}'
  end

  s.subspec 'Utility' do |ss|
    ss.dependency 'ZHJKit/Marco'
    ss.public_header_files = 'ZHJKit/Utility/*.h'
    ss.source_files = 'ZHJKit/Utility/*.{h,m}'
  end

end
