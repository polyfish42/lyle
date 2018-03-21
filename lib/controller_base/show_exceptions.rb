require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue => e
      content = render_exception(e)
      ['500', {'Content-type' => "text/html"}, content]
    end
  end

  private

  def render_exception(e)
    error = e
    path = "public/templates/rescue.html.erb"
    ERB.new(File.read(path)).result(binding)
  end
end
