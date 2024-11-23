#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint quill_native_bridge_ios.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'quill_native_bridge_ios'
  s.version          = '0.0.1'
  s.summary          = 'A plugin for flutter_quill'
  s.description      = <<-DESC
An internal plugin for flutter_quill package to access platform-specific APIs.
                       DESC
  s.homepage         = 'https://github.com/FlutterQuill/quill-native-bridge/tree/main/quill_native_bridge'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Flutter Quill' => 'https://github.com/singerdmx/flutter-quill' }
  s.source           = { :http => 'https://github.com/FlutterQuill/quill-native-bridge/tree/main/quill_native_bridge_ios' }
  s.source_files = 'quill_native_bridge_ios/Sources/quill_native_bridge_ios/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.resource_bundles = {'quill_native_bridge_ios_privacy' => ['quill_native_bridge_ios/Sources/quill_native_bridge_ios/Resources/PrivacyInfo.xcprivacy']}
end
