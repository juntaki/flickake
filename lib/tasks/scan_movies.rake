namespace :movies do
  desc "Scan movie files and update DB"
  task :scan => :environment do
    Movie.delete_all
    # TODO: Skip deletion for faster scan
    Dir.glob(Rails.root.join("files/*")).each do |m|
      next if m.include?("thumb")
      puts m
      system("ffmpegthumbnailer -s 512 -i #{m} -o#{m}.thumb.jpg")
      Movie.create(
        title: File.basename(m),
        date: File.mtime(m),
        thumbnail: m + '.thumb.jpg',
      )
    end
  end
end
