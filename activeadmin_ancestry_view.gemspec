$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "activeadmin_ancestry_view/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activeadmin_ancestry_view"
  s.version     = ActiveadminAncestryView::VERSION
  s.authors     = ["Dimkarodinz"]
  s.email       = ["dimkarodin@gmail.com"]
  s.homepage    = "http://127.0.0.1"
  s.summary     = "Ancestry tree view in ActiveAdmin resource"
  s.description = "Ancestry tree view in ActiveAdmin resource"
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile"]

  s.add_dependency "rails", "~> 4.2.7.1"

  s.add_runtime_dependency 'activeadmin', '>= 1.0.0.pre4'
  s.add_runtime_dependency 'jquery-rails'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'slim-rails'
  s.add_development_dependency "bundler", "~> 1.13"
  s.add_development_dependency "rake", "~> 10.0"
end
