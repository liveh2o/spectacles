require "bundler/gem_tasks"
require 'rake/testtask'

namespace :test do
  adapters = [:abstract, :mysql, :mysql2, :postgresql, :sqlite]
  task :all => adapters

  adapters.each do |adapter|
    Rake::TestTask.new(adapter) do |t|
      t.libs.push "lib"
      t.libs.push "specs"
      t.pattern = "specs/**/#{t.name}*_spec.rb"
      t.verbose = true
    end
  end
end

task :default => 'test:all'
