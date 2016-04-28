namespace :ridgepole do
  desc 'Create a Schemafile file that is portable against any DB supported by Ridgepole'
  task :export, :rails_env do |_, args|
    rails_env = args[:rails_env] || ENV['RAILS_ENV'] || 'development'
    redirect = rails_env == 'test' ? '> /dev/null' : ''
    sh [
      'ridgepole --export -o Schemafile',
      "-E #{rails_env}",
      '-c config/database.yml',
      "--ignore-tables '#{ignore_tables}'",
      redirect
    ].join(' ')
  end

  desc 'Apply a Schemafile file into the database'
  task :apply, :rails_env do |_, args|
    rails_env = args[:rails_env] || ENV['RAILS_ENV'] || 'development'
    redirect = rails_env == 'test' ? '> /dev/null' : ''
    sh [
      'ridgepole --apply',
      "-E #{rails_env}",
      '-c config/database.yml',
      "--ignore-tables '#{ignore_tables}'",
      redirect
    ].join(' ')
  end

  def ignore_tables
    ActiveRecord::SchemaDumper.ignore_tables.map(&:source).join(',')
  end
end

Rake.application.lookup('db:migrate').clear
desc 'Migrate the database by Ridgepole'
task 'db:migrate' do
  Rake::Task['ridgepole:apply'].invoke
  Rake::Task['ridgepole:export'].invoke
  Annotate::Migration.update_annotations if Rails.env.development?
end

Rake.application.lookup('db:schema:dump').clear
desc 'Create a Schemafile file that is portable against any DB supported by Ridgepole'
task 'db:schema:dump' => 'ridgepole:export'

Rake.application.lookup('db:schema:load').clear
desc 'Apply a Schemafile file into the database'
task 'db:schema:load' => 'ridgepole:apply'

Rake.application.lookup('db:test:load').clear
task 'db:test:load' => %w(db:test:purge) do
  Rake::Task['ridgepole:apply'].invoke('test')
end

%w(db:migrate:status db:rollback db:version).each do |name|
  Rake.application.lookup(name).clear
end
