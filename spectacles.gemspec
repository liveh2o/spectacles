# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spectacles/version"

Gem::Specification.new do |s|
  s.name        = "spectacles"
  s.version     = Spectacles::VERSION
  s.authors     = ["Adam Hutchison, Brandon Dewitt"]
  s.email       = ["liveh2o@gmail.com, brandonsdewitt@gmail.com"]
  s.homepage    = "http://github.com/liveh2o/spectacles"
  s.summary     = %q{Spectacles (derived from RailsSQLViews) adds database view functionality to ActiveRecord.}
  s.description = %q{Still working out some of the kinks. Almost ready for Prime Time(TM). If you decide to use it and have problems, please report them at github.com/liveh2o/spectactles/issues}

  s.rubyforge_project = "spectacles"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "minitest"
  s.add_development_dependency "mysql"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "pg"
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3-ruby"

  s.add_runtime_dependency "activerecord"
  s.add_runtime_dependency "activesupport"
end
