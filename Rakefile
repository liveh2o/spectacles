# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

namespace :test do
  Minitest::TestTask.create :spectacles do |t|
    t.test_globs = ["test/spectacles/**/*_test.rb"]
    t.warning = false
  end

  adapters = %i[mysql2 postgresql sqlite3]
  adapters.each do |adapter|
    Minitest::TestTask.create adapter do |t|
      t.test_globs = ["test/adapters/#{t.name}*_test.rb"]
      t.warning = false
    end
  end

  task all: %i[spectacles] + adapters
end

require "standard/rake"

task default: %i[test:all standard:fix]
