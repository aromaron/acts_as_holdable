$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "acts_as_booked/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_booked"
  s.version     = ActsAsBooked::VERSION
  s.authors     = ["Nora Alvarado"]
  s.email       = ["nora@michelada.io"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ActsAsBooked."
  s.description = "TODO: Description of ActsAsBooked."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "sqlite3"
end
