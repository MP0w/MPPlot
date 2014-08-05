#
# Be sure to run `pod lib lint MPPlot.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MPPlot"
  s.version          = "0.1.0"
  s.summary          = "Create iOS native Graphs easily , fast and customizable."
  s.description      = <<-DESC
                       Create iOS native Graphs easily , fast and customizable...
                       DESC
  s.homepage         = "https://github.com/MP0w/MPPlot"
s.screenshots     = "https://raw.githubusercontent.com/MP0w/MPPlot/master/images/graph.gif"
  s.license          = 'BSD'
  s.author           = { "Alex Manzella" => "manzopower@icloud.com" }
  s.source           = { :git => "https://github.com/MP0w/MPPlot.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/manzopower'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/'

end
