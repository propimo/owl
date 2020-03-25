namespace :vacuum do
  desc "VACUMM FULL"
  task full: :environment do
    sql = ActiveRecord::Base.connection
    sql.execute("VACUUM FULL;")
  end
end
