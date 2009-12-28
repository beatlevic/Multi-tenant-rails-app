require 'active_record'
require 'pg'

namespace :pg do
  desc 'Migrates all postgres schemas'
  task :migrate => [ 'pg:migrate:public', 'pg:migrate:schemas' ]

  desc 'List all postgres schemas'
  task :schemas do
    env = "#{RAILS_ENV}"
    config = YAML::load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(config[env])
    schemas = ActiveRecord::Base.connection.select_values("select * from pg_namespace where nspname not in ('public','information_schema') AND nspname NOT LIKE 'pg%'").inspect
    puts schemas
  end

  namespace :migrate do

    desc 'Migrates public postgres schema'
    task :public do
      puts "Migrate public schema"
      env = "#{RAILS_ENV}"
      config = YAML::load(File.open('config/database.yml'))
      config[env]["schema_search_path"] = "public"
      ActiveRecord::Base.establish_connection(config[env])
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end

    desc 'Migrates all other postgres schemas'
    task :schemas do
      # get all schemas
      env = "#{RAILS_ENV}"
      config = YAML::load(File.open('config/database.yml'))
      ActiveRecord::Base.establish_connection(config[env])
      schemas = ActiveRecord::Base.connection.select_values("select * from pg_namespace where nspname not in ('public','information_schema') AND nspname NOT LIKE 'pg%'")
      puts "Migrate schemas: #{schemas.inspect}"
      # migrate each schema
      schemas.each do |schema|
        puts "Migrate schema: #{schema}"
        config = YAML::load(File.open('config/database.yml'))
        config[env]["schema_search_path"] = schema
        ActiveRecord::Base.establish_connection(config[env])
        ActiveRecord::Base.logger = Logger.new(STDOUT)
        ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
      end
    end
  end

end


# env = "#{RAILS_ENV}"
# puts "Migrating postgres schemas for #{env} through scripts in db/migrate. Target specific version with VERSION=x"
# ["public", "gee", "martial_heroes"].each do |schema|
#   puts "Migrate schema: #{schema}"
#   config = YAML::load(File.open('config/database.yml'))
#   #puts config[env].inspect
#   config[env]["schema_search_path"] = schema
#   ActiveRecord::Base.establish_connection(config[env])
#   puts "Connection established"
#   ActiveRecord::Base.logger = Logger.new(STDOUT)
#   ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
#   Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby and schema == "public"
# end

