#
# Be sure to run `pod lib lint MinimalNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MinimalNetworking'
  s.version          = '0.2.0'
  s.summary          = 'A minimalist networking library for iOS projects.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A simple networking library for iOS that emphasises brevity. It's dependency free, and
uses a simple result enum to handle its (asynchronous) requests.
                       DESC

  s.homepage         = 'https://github.com/Firanus/MinimalNetworking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Firanus' => 'ivan.useful@gmail.com' }
  s.source           = { :git => 'https://github.com/Firanus/MinimalNetworking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.3'
  s.swift_version = '4.1'

  s.source_files = 'MinimalNetworking/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MinimalNetworking' => ['MinimalNetworking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
