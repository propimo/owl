namespace :db do
  task fresh_shuffle: :environment do
    raise StandardError, 'This task cannot be executed in production environment!' if Rails.env.production?

    parser = TaskOptionParser.new
    options = parser.parse!

    Rake::Task['db:update_local'].invoke(opts_string(options, keys: %i[local_db remote_db dump host user], prepend_arg: true))

    unless Rake::Task.task_defined?('db:shuffle')
      raise StandardError, 'You need specify your own db:shuffle task!'
    end

    Rake::Task['db:shuffle'].invoke(opts_string(options, keys: %i[out], prepend_arg: true))
    Rake::Task['db:process_dump'].invoke(opts_string(options, keys: %i[local_db out], prepend_arg: true))
  end
end
