class Movie < ApplicationRecord
  def self.scan
    Movie.delete_all
    # TODO: Skip deletion for faster scan
    Dir.glob(Rails.root.join("files/*")).each do |m|
      next if m.include?("thumb")
      next if File.directory?(m)
      system("ffmpegthumbnailer -s 512 -i #{m} -o #{m}.thumb.jpg")
      Movie.create(
        title: File.basename(m),
        date: File.mtime(m),
        thumbnail: m + '.thumb.jpg',
      )
    end
  end
end
