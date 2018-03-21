require 'byebug'

class Static
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    regex = Regexp.new("/public/(?<path>.+)")
    path = env['PATH_INFO']

    if path =~ regex
      match_data = regex.match(path)

      begin
        content = File.read("app/public/#{match_data[:path]}")
      rescue
        return [404, {"Content-type" => "text/html"}, "<h1>Sorry, we couldn't find that.</h1>"]
      end
      file_ext = Regexp.new('/\.\w{3}').match(path)

      mime_type = mime_type(file_ext)

      [200, {"Mime-type" => "#{mime_type}"}, content]
    else
      @app.call(env)
    end
  end

  private

  def mime_type(file_ext)
    image_file_types = %w(jpg png)
    text_file_types = %w(txt)
    other_file_types = %w(zip)

    mime_type = nil

    if image_file_types.include?(file_ext)
      mime_type = "image/#{file_ext}"
    elsif text_file_types.include?(file_ext)
      mime_type = "text/#{file_ext}"
    elsif other_file_types.include?(file_ext)
      mime_type = "text/#{file_ext}"
    else
      mime_type = "text/css"
    end
  end
end
