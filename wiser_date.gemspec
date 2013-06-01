Gem::Specification.new do |s|
  s.name        = 'wiser_date'
  s.version     = '0.2.8'
  s.date        = '2012-06-01'
  s.summary     = "Gorgeous real-time date display plugin"
  s.description = "Gorgeous real-time date display plugin"
  s.authors     = ["Kenneth John Balgos"]
  s.email       = 'kennethjohnbalgos@gmail.com'
  s.files       = ["vendor/assets/javascripts/jquery.wiser_date.js", "lib/wiser_date/view_helpers.rb", "lib/wiser_date/railtie.rb", "lib/wiser_date.rb", "README.rdoc"]
  s.license     = 'MIT'
  s.homepage    = "https://github.com/kennethjohnbalgos/wiser_date"
  s.add_dependency('rails', '>= 3.1')
end