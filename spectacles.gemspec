# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spectacles/version"

Gem::Specification.new do |gem|
  gem.version     = Spectacles::VERSION
  gem.name        = "spectacles"
  gem.authors     = ["Adam Hutchison, Brandon Dewitt"]
  gem.email       = ["liveh2o@gmail.com, brandonsdewitt@gmail.com"]
  gem.homepage    = "http://github.com/liveh2o/spectacles"
  gem.summary     = %q{Spectacles (derived from RailsSQLViews) adds database view functionality to ActiveRecord.}
  gem.description = %q{Still working out some of the kinks. Almost ready for Prime Time(TM). If you decide to use it and have problems, please report them at github.com/liveh2o/spectactles/issues}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  ##
  # Dependencies
  #
  gem.add_dependency "activerecord", ">= 4.0.0"
  gem.add_dependency "activesupport", ">= 4.0.0"

  ##
  # Development dependencies
  #
  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
end
