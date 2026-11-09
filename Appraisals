# frozen_string_literal: true

# One appraisal for each supported Rails minor version.
#
# JRuby uses the prerelease JDBC adapter gems from RubyGems. The git sources
# do not include the compiled adapter jar, so they do not load.
# Rails 8.1 has only the SQLite JDBC adapter so far, so JRuby CI runs only
# the SQLite tests on Rails 8.1.
appraise "rails-8.0" do
  gem "activerecord", "~> 8.0.0"
  gem "activesupport", "~> 8.0.0"

  platforms :jruby do
    gem "activerecord-jdbc-adapter", "~> 80.0.pre1"
    gem "activerecord-jdbcmysql-adapter", "~> 80.0.pre1"
    gem "activerecord-jdbcpostgresql-adapter", "~> 80.0.pre1"
    gem "activerecord-jdbcsqlite3-adapter", "~> 80.0.pre1"
  end
end

appraise "rails-8.1" do
  gem "activerecord", "~> 8.1.0"
  gem "activesupport", "~> 8.1.0"

  platforms :jruby do
    gem "activerecord-jdbc-adapter", "~> 81.0.pre1"
    gem "activerecord-jdbcsqlite3-adapter", "~> 81.0.pre1"
  end
end
