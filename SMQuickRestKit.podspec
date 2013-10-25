Pod::Spec.new do |s|
  s.name     = 'SMQuickRestKit'
  s.version  = '0.1'
  s.license  = 'MIT'
  s.summary  = 'RestKit and MagicalRecord wrapper for quick project setup'
  s.homepage = 'http://www.stefanomondino.com'
  s.author   = { 'Stefano Mondino' => 'stefano.mondino.dev@gmail.com' }

  s.description = 'Work in progress'

  s.source   = { :git => 'git@github.com:stefanomondino/SMQuickRestKit.git' }
  s.requires_arc = true
  s.source_files = 'SMQuickRestKit/*.{m,h}'
  s.dependency 'RestKit'
  s.dependency 'MagicalRecord'
  s.frameworks = 'SystemConfiguration' , 'MobileCoreServices'


end
