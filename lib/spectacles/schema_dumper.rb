module Spectacles
  module SchemaDumper
    def self.dump_views(stream, connection)
      unless (Spectacles.config.enable_schema_dump == false)
        connection.views.sort.each do |view|
          dump_view(stream, connection, view)
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
  end
end
