require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.libs.push "specs"
  t.pattern = 'specs/**/*_spec.rb'
  t.verbose = true
end

task :spec => :test
task :default => :spec
