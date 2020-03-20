namespace :db do
  task process_dump: :environment do
    parser = TaskOptionParser.new
    options = parser.parse!

    puts "Processing dump of #{options[:local_db]} database..."
    p options[:local_db]
    %x(pg_dump -O -x -Fc -d #{options[:local_db]} > #{options[:out]})
    puts "Shuffled dump processed into #{options[:out]}"
  end
end
