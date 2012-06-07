$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "one_more_rating/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "one_more_rating"
  s.version     = OneMoreRating::VERSION
  s.authors     = ["Andrey Smirnov"]
  s.email       = ["anderson.smirnov@gmail.com"]
  s.homepage    = "https://github.com/andersonspb/one_more_rating"
  s.summary     = "One more star rating plugin"
  s.description = "One more star rating plugin with some unique features"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"
  # s.add_dependency "jquery-rails"

end
