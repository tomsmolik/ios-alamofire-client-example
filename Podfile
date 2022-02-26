def common_pods
   pod 'Alamofire'
   pod 'RxSwift'
   pod 'RxCocoa'
end

target 'ApiClientExample' do
    platform :ios, '13'
    
    use_frameworks!
    inhibit_all_warnings!
    
    common_pods
end

post_install do |installer|

installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13'
  end
end

# ARM Mac simulator build fix
# https://stackoverflow.com/a/63955114
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
