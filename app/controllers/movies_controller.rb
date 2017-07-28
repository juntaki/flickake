class MoviesController < ApplicationController
  RANGE_LIMIT = 1024 * 1024
  def static
    movie = Movie.find(params[:id])
    # TODO: should be served from web server
    file_name = movie.title
    file_path = Rails.root.join("files", file_name)
    if(request.headers["range"])
      file_size = File.size(file_path)

      offset = 0
      file_end = offset + RANGE_LIMIT

      if match = request.headers['range'].match(/bytes=(\d+)-(\d*)/)
        offset = match[1].to_i
        unless match[2].empty?
          file_end = match[2].to_i
        else
          file_end = offset + RANGE_LIMIT
          file_end = file_size - 1  if file_size - 1 < file_end
        end
      end
      length = file_end - offset + 1

      response.header["Content-Range"] = "bytes " + offset.to_s + "-" + file_end.to_s + "/" + file_size.to_s
      response.header["Content-Type"] = "video/mp4"
      response.header["Content-Length"] = length.to_s
      response.header["Accept-Ranges"] = "bytes"
      response.headers['Content-Transfer-Encoding'] = 'binary'

      send_data(IO.binread(file_path,length,offset),
                :status => 206,
                :type => "video/mp4",
                :disposition => 'inline'
               )
    else
      send_file(file_path)
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def list
    @list = Movie.order('date DESC')
    if params[:format] == 'json'
      render :json => @list
    end
  end

  def thumb
    send_file Movie.find(params[:id]).thumbnail, :disposition => 'inline'
  end

  def scan
    Movie.scan
  end
end
