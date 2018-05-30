$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "acts_as_holdable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_holdable"
  s.version     = ActsAsHoldable::VERSION
  s.authors     = ["Nora Gabriela Alvarado"]
  s.email       = ["noragmora@gmail.com"]
  s.homepage    = "https://gitlab.com/aromaron/acts_as_holdable"
  s.summary     = "Summary of ActsAsHoldable."
  s.description = "Description of ActsAsHoldable."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "combustion"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "coveralls"
end
