# frozen_string_literal: true

require_relative "lib/spectacles/version"

Gem::Specification.new do |spec|
  spec.version = Spectacles::VERSION
  spec.name = "spectacles"
  spec.authors = ["Adam Hutchison, Brandon Dewitt"]
  spec.email = ["liveh2o@gmail.com, brandonsdewitt@gmail.com"]

  spec.summary = "Spectacles adds database view functionality to ActiveRecord."
  spec.description = "Spectacles adds database view functionality to ActiveRecord. Current supported adapters include Postgres, SQLite, Vertica, and MySQL."
  spec.homepage = "http://github.com/liveh2o/spectacles"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "~> 7.1.0"
  spec.add_dependency "activesupport", "~> 7.1.0"

  spec.add_development_dependency "minitest", ">= 5.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "standard"
end
