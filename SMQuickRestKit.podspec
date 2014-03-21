Pod::Spec.new do |s|
  s.name     = 'SMQuickRestKit'
  s.version  = '0.2.0'
  s.license  = 'MIT'
  s.summary  = 'RestKit and MagicalRecord wrapper for quick project setup'
  s.homepage = 'http://www.stefanomondino.com'
  s.author   = { 'Stefano Mondino' => 'stefano.mondino.dev@gmail.com' }

  s.description = 'RestKit and MagicalRecord wrapper for quick project setup. '

  s.source   = { :git => "https://github.com/stefanomondino/SMQuickRestKit.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.ios.deployment_target = '5.0'
  s.source_files = 'SMQuickRestKit/*.{m,h}'
  s.dependency 'RestKit'
  s.dependency 'MagicalRecord'
  


end
