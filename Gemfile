source "http://rubygems.org"

# Specify your gem's dependencies in spectacles.gemspec
gemspec

platforms :jruby do
  gem "activerecord-jdbcmysql-adapter"
  gem "activerecord-jdbcpostgresql-adapter"
  gem "activerecord-jdbcsqlite3-adapter"
end

platforms :ruby do
  gem "mysql2"
  gem "pg"
  gem "sqlite3"
end

group :test do
  gem "simplecov", require: false
end
