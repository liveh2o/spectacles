module Spectacles
  module SchemaDumper
    def self.dump_views(stream, connection)
      connection.views.each do |view|
        dump_view(stream, connection, view)
      end
    end

    def self.dump_view(stream, connection, view_name)
      stream.print <<-CREATEVIEW
  create_view :#{view_name} do
    "#{connection.view_build_query(view_name)}"
  end
      CREATEVIEW
    end
  end
end
