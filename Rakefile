require "bundler/gem_tasks"
require 'rake/testtask'

namespace :test do
  adapters = [ :mysql2, :postgresql, :sqlite3 ]
  task :all => [ :spectacles ] + adapters

  adapters.each do |adapter|
    Rake::TestTask.new(adapter) do |t|
      t.libs.push "lib"
      t.libs.push "specs"
      t.pattern = "specs/adapters/#{t.name}*_spec.rb"
      t.verbose = true
    end
  end

  Rake::TestTask.new(:spectacles) do |t|
    t.libs.push "lib"
    t.libs.push "specs"
    t.pattern = "specs/spectacles/**/*_spec.rb"
    t.verbose = true
  end
end

task :default => 'test:all'
