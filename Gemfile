source "https://rubygems.org"

# Specify your gem's dependencies in spectacles.gemspec
gemspec

platforms :jruby do
  gem "activerecord-jdbc-adapter",
    git: "https://github.com/jruby/activerecord-jdbc-adapter",
    glob: "activerecord-jdbc-adapter.gemspec"
  gem "activerecord-jdbcsqlite3-adapter",
    git: "https://github.com/jruby/activerecord-jdbc-adapter",
    glob: "activerecord-jdbcsqlite3-adapter/activerecord-jdbcsqlite3-adapter.gemspec"
  gem "activerecord-jdbcpostgresql-adapter",
    git: "https://github.com/jruby/activerecord-jdbc-adapter",
    glob: "activerecord-jdbcpostgresql-adapter/activerecord-jdbcpostgresql-adapter.gemspec"
  gem "activerecord-jdbcmysql-adapter",
    git: "https://github.com/jruby/activerecord-jdbc-adapter",
    glob: "activerecord-jdbcmysql-adapter/activerecord-jdbcmysql-adapter.gemspec"
end

platforms :ruby do
  gem "mysql2"
  gem "pg"
  gem "sqlite3"
end

group :test do
  gem "simplecov", require: false
end
