lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spectacles/version"

Gem::Specification.new do |gem|
  gem.version = Spectacles::VERSION
  gem.name = "spectacles"
  gem.authors = ["Adam Hutchison, Brandon Dewitt"]
  gem.email = ["liveh2o@gmail.com, brandonsdewitt@gmail.com"]
  gem.homepage = "http://github.com/liveh2o/spectacles"
  gem.summary = "Spectacles (derived from RailsSQLViews) adds database view functionality to ActiveRecord."
  gem.description = "Spectacles adds database view functionality to ActiveRecord. Current supported adapters include Postgres, SQLite, Vertica, and MySQL."
  gem.license = "MIT"

  gem.files = `git ls-files`.split($\)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  ##
  # Dependencies
  #
  gem.required_ruby_version = ">= 2.6.0"
  gem.add_dependency "activerecord", ">= 6.1.0", "< 7.1"
  gem.add_dependency "activesupport", ">= 6.1.0", "< 7.1"

  ##
  # Development dependencies
  #
  gem.add_development_dependency "minitest", ">= 5.0"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "standard"
end
