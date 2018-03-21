class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    req.request_method == @http_method.to_s.upcase && req.path =~ @pattern
  end

  def run(req, res)
    # params = @pattern.match(req.path)
    # params_hash = {}

    # params.names.each do |name|
    #   params_hash[name] = params[name]
    # end

    params = Rack::Utils.parse_nested_query req.body.read

    controller = @controller_class.new(req, res, params)
    controller.invoke_action(@action_name.to_sym)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method http_method do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.find do |route|
      route.matches?(req)
    end
  end

  def run(req, res)
    route = match(req)

    if route
      route.run(req, res)
    else
      res.status = 404
      res.write("I'm sorry, but that page was not found.")
    end
  end
end
