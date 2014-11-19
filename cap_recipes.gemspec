Gem::Specification.new do |s|
  s.name        = "cap_recipes"
  s.version     = "0.0.3"
  s.author      = "Enrique Alvarez"
  s.email       = "enrique@codecantor.com"
  s.homepage    = "http://github.com/codecantor/cap_recipes"
  s.summary     = "A collection of capistrano tasks and a generator for capistrano"
  s.description = "A collection of capistrano tasks and a generator for capsitrano used in codecantor"

  s.files        = Dir["{lib,tasks}/**/*", "[A-Z]*"]
  s.require_path = "lib"

  s.add_dependency 'capistrano', '~> 3.2.1'
end
