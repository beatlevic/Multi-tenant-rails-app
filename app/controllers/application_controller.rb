# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

module SchemaUtils
  def self.add_schema_to_path(schema)
    conn = ActiveRecord::Base.connection
    conn.execute("SET search_path TO #{schema}, #{conn.schema_search_path}")
  end

  def self.create_schema(schema)
    conn = ActiveRecord::Base.connection
    conn.execute("CREATE SCHEMA #{schema}")
  end
end

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
