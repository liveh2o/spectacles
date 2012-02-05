# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spectacles/version"

Gem::Specification.new do |s|
  s.name        = "spectacles"
  s.version     = Spectacles::VERSION
  s.authors     = ["Adam Hutchison"]
  s.email       = ["adam.hutchison@moneydesktop.com"]
  s.homepage    = ""
  s.summary     = %q{DON'T USE THIS YET}
  s.description = %q{Almost ready for Prime Time(TM)}

  s.rubyforge_project = "spectacles"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "minitest"
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "pg"

  s.add_runtime_dependency "activerecord"
  s.add_runtime_dependency "activesupport"
end
