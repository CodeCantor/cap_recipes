Gem::Specification.new do |s|
  s.name        = "cap_recipes"
  s.version     = "0.0.1"
  s.author      = "Enrique Alvarez"
  s.email       = "enrique@codecantor.com"
  s.homepage    = "http://github.com/codecantor/cap_recipes"
  s.summary     = "A collection of capistrano tasks and a generator for capistrano"
  s.description = "A collection of capistrano tasks and a generator for capsitrano used in codecantor"

  s.files        = Dir["{lib,tasks}/**/*", "[A-Z]*"]
  s.require_path = "lib"

  s.add_development_dependency 'capistrano', '~> 2.14.2'
  s.add_development_dependency 'capistrano-ext', '~> 1.2.1'
  s.add_development_dependency 'capistrano-chef', '~> 0.0.6'
  s.add_development_dependency 'rvm-capistrano', '~> 1.2.7'
end
