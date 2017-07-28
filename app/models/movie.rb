class Movie < ApplicationRecord
  def self.scan
    Movie.update_all(delflag: true)
    Dir.glob(Rails.root.join("files/*")).each do |m|
      next if m.include?("thumb")
      next if File.directory?(m)
      movie = Movie.where(title: File.basename(m))
      unless movie.size == 0
        movie.update(delflag: false)
        next
      end
      system("ffmpegthumbnailer -s 512 -i #{m} -o #{m}.thumb.jpg")
      Movie.create(
        title: File.basename(m),
        date: File.mtime(m),
        thumbnail: m + '.thumb.jpg',
      )
    end
    Movie.where(delflag: true).delete_all
  end
end
