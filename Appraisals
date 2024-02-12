appraise "rails-42" do
  gem "activerecord", "~> 4.2"
  platforms :ruby do
    gem 'pg', '~> 0.20'
    gem "sqlite3", '~> 1.3.13'
  end

  platforms :jruby do
    gem "activerecord-jdbcpostgresql-adapter", "= 1.3.25"
    gem "activerecord-jdbcsqlite3-adapter", "= 1.3.25"
  end
end

appraise "rails-52" do
  gem "activerecord", "~> 5.2", "< 6"
  platforms :jruby do
    gem "activerecord-jdbcpostgresql-adapter", ">= 52", "< 60"
    gem "activerecord-jdbcsqlite3-adapter", ">= 52", "< 60"
  end
end

appraise "rails-61" do
  gem "activerecord", "~> 6.1", "< 6.2"
  gem "protobuf-activerecord", ">= 6.1"
  platforms :jruby do
    gem "activerecord-jdbcpostgresql-adapter", ">= 61", "< 62"
    gem "activerecord-jdbcsqlite3-adapter", ">= 61", "< 62"
  end
end
