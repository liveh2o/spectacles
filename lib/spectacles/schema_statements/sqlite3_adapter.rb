require 'spectacles/schema_statements/abstract_adapter'
require 'spectacles/schema_statements/sqlite_backports'

module Spectacles
  module SchemaStatements
    module SQLite3Adapter
      extend ActiveSupport::Concern

      include Spectacles::SchemaStatements::AbstractAdapter
      include Spectacles::SchemaStatements::SqliteBackports

      # This rather ugly hack is necessary because of how Spectacles
      # auto-installs itself. In spectacles.rb, an +inherited+ hook is
      # defined that calls +Spectacles.load_adapters+ every time a new
      # subclass of +ActiveRecord::ConnectionAdapter::AbstractAdapter+
      # is defined. The problem is that the +inherited+ hook is called
      # immediately after the class is opened, and before any methods
      # have been added. Thus, when this module
      # (+Spectacles::SchemaStatements::SQLite3Adapter+) gets
      # included into the Rails adapter class, the adapter has no methods
      # in it, which means any attempts to alias the +tables+ method (so
      # it can be redefined) will fail (because the method doesn't exist
      # yet). The solution implemented here checks to see if the +tables+
      # method exists, and if it does not, it adds a +method_added+
      # hook (yuck) and waits for the +tables+ method to be added. At
      # that point, then, it sets up the aliases.
      #
      # Hardly ideal, but it seemed the least of all the other evil
      # methods that occurred to me (overriding #require, etc.)
      #
      # The cleanest solution uses Module#prepend, but the need to
      # support jRuby < 9k means we can't go that route yet.
      included do
        if instance_methods.include?(:tables)
          alias_method :tables_with_views, :tables
          alias_method :tables, :tables_without_views
        else
          def self.method_added(method_name)
            if method_name == :tables && !instance_methods.include?(:tables_with_views)
              alias_method :tables_with_views, :tables
              alias_method :tables, :tables_without_views
            end
          end
        end
      end

      def generate_view_query(*columns)
        sql = <<-SQL
          SELECT #{columns.join(',')}
          FROM sqlite_master
          WHERE type = 'view'
        SQL
      end

      def views #:nodoc:
        sql = generate_view_query(:name)

        exec_query(sql, "SCHEMA").map do |row|
          row['name']
        end
      end

      def view_build_query(table_name)
        sql = generate_view_query(:sql)
        sql << " AND name = #{quote_table_name(table_name)}"

        row = exec_query(sql, "SCHEMA").first
        row['sql'].gsub(/CREATE VIEW .*? AS/i, "")
      end
    end
  end
end
