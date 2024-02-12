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
  gem 'pg', '~> 0.20'
  gem "sqlite3", '~> 1.4.2'
end

group :test do
  gem 'simplecov', :require => false
end
