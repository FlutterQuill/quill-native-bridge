#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint quill_native_bridge_macos.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'quill_native_bridge_macos'
  s.version          = '0.0.1'
  s.summary          = 'A plugin for flutter_quill'
  s.description      = <<-DESC
An internal plugin for flutter_quill package to access platform-specific APIs.
                       DESC
  s.homepage         = 'https://github.com/FlutterQuill/quill-native-bridge/tree/main/quill_native_bridge'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Flutter Quill' => 'https://github.com/singerdmx/flutter-quill' }
  s.source           = { :http => 'https://github.com/FlutterQuill/quill-native-bridge/tree/main/quill_native_bridge_macos' }
  s.source_files = 'quill_native_bridge_macos/Sources/quill_native_bridge_macos/**/*.swift'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.14'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'

  s.resource_bundles = {'quill_native_bridge_macos_privacy' => ['quill_native_bridge_macos/Sources/quill_native_bridge_macos/Resources/PrivacyInfo.xcprivacy']}
end
