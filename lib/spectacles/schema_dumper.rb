module Spectacles
  module SchemaDumper
    def self.dump_views(stream, connection)
      unless (Spectacles.config.enable_schema_dump == false)
        connection.views.sort.each do |view|
          dump_view(stream, connection, view)
        end
      end
    end

    def self.dump_materialized_views(stream, connection)
      unless (Spectacles.config.enable_schema_dump == false)
        if connection.supports_materialized_views?
          connection.materialized_views.sort.each do |view|
            dump_materialized_view(stream, connection, view)
          end
        end
      end
    end

    def self.dump_view(stream, connection, view_name)
      stream.print <<-CREATEVIEW

  create_view :#{view_name}, :force => true do
    "#{connection.view_build_query(view_name)}"
  end

      CREATEVIEW
    end

    def self.dump_materialized_view(stream, connection, view_name)
      definition, options = connection.materialized_view_build_query(view_name)
      options[:force] = true

      stream.print <<-CREATEVIEW

  create_materialized_view #{view_name.to_sym.inspect}, #{format_option_hash(options)} do
    <<-SQL
      #{definition}
    SQL
  end
      CREATEVIEW
    end

    def self.format_option_hash(hash)
      hash.map do |key, value|
        "#{key}: #{format_option_value(value)}"
      end.join(", ")
    end

    def self.format_option_value(value)
      case value
      when Hash then "{ #{format_option_hash(value)} }"
      when /^\d+$/ then value.to_i
      when /^\d+\.\d+$/ then value.to_f
      when true, false then value.inspect
      else raise "can't format #{value.inspect}"
      end
    end
  end
end
