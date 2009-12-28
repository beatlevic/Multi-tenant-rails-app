require 'active_record'
require 'pg'

namespace :pg do
  desc 'Migrates all postgres schemas'
  task :migrate do
    env = "#{RAILS_ENV}"
    puts "Migrating postgres schemas for #{env} through scripts in db/migrate. Target specific version with VERSION=x"
    ["public", "gee", "martial_heroes"].each do |schema|
      puts "Migrate schema: #{schema}"
      config = YAML::load(File.open('config/database.yml'))
      #puts config[env].inspect
      config[env]["schema_search_path"] = schema
      ActiveRecord::Base.establish_connection(config[env])
      puts "Connection established"
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby and schema == "public"
    end
  end

  desc 'List all postgres schemas'
  task :schemas do
    env = "#{RAILS_ENV}"
    config = YAML::load(File.open('config/database.yml'))
    config[env]["schema_search_path"] = "public"
    ActiveRecord::Base.establish_connection(config[env])
    puts ActiveRecord::Base.connection.select_values("select * from pg_namespace").inspect
  end
end

