namespace :movies do
  desc "Scan movie files and update DB"
  task :scan => :environment do
    Movie.scan
  end
end
