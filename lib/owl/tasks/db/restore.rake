namespace :db do
  task restore: :environment do
    raise StandardError, 'This task cannot be executed in production environment!' if Rails.env.production?

    parser = TaskOptionParser.new
    options = parser.parse!

    raise StandardError, 'No database provided in configuration file!' if options[:local_db].blank?

    raise StandardError, "No file '#{options[:dump]}' was found in project's directory!" unless File.exist?(options[:dump])
    puts "Restoring local database #{options[:local_db]} from #{options[:dump]}..."

    puts "Removing local database #{options[:local_db]}..."
    %x(dropdb #{options[:local_db]})
    puts "Creating local database #{options[:local_db]}..."
    %x(createdb #{options[:local_db]})

    puts "Applying dump file #{options[:dump]} to local database #{options[:local_db]}..."
    %x(pg_restore -O -x -Fc -d #{options[:local_db]} #{options[:dump]})
  end
end
