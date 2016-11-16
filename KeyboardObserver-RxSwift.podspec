Pod::Spec.new do |s|
  s.name             = 'KeyboardObserver-RxSwift'
  s.version          = '0.1.0'
  s.summary          = 'Keyboard event handler with rxswift.'

  s.description      = <<-DESC
Keyboard event handler with rxswift. Supported subscribe and method chain.
                       DESC

  s.homepage         = 'https://github.com/noppefoxwolf/KeyboardObserver-RxSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tomoya Hirano' => 'cromteria@gmail.com' }
  s.source           = { :git => 'https://github.com/noppefoxwolf/KeyboardObserver-RxSwift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/noppefoxwolf'
  s.ios.deployment_target = '9.0'
  s.source_files = 'KeyboardObserver-RxSwift/Classes/**/*'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
end
