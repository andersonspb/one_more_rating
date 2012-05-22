$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "one_more_rating/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "one_more_rating"
  s.version     = OneMoreRating::VERSION
  s.authors     = ["Andrey Smirnov"]
  s.email       = ["anderson.smirnov@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "One more star rating plugin"
  s.description = "TODO: Description of OneMoreRating."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.textile"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"
  # s.add_dependency "jquery-rails"

end
