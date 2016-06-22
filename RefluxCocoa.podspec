Pod::Spec.new do |s|
  s.name             = 'RefluxCocoa'
  s.version          = '0.1.0'
  s.summary          = 'An implementation of Reflux in Objective-C'
  s.ios.deployment_target = '7.0'
  s.homepage = 'https://github.com/guangmingzizai/RefluxCocoa'

  s.description      = <<-DESC
This library is An implementation of Reflux in Objective-C. It introduce a more functional programming style architecture by eschewing MVC like pattern and adopting a single data flow pattern.
                       DESC
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'guangmingzizai' => 'guangmingzizai@qq.com' }
  s.source           = { :git => 'https://github.com/guangmingzizai/RefluxCocoa.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'

  s.source_files = 'RefluxCocoa/Classes/**/*'
end
