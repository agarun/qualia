class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  # given a Rack::Request object, find which Route matches the requested path
  # by using a regular expression via a `Regexp` object
  # then, instantiate the Route's controller, and run the appropriate method
  # @param pattern [Regexp] a Regexp pattern object
  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  # true if pattern matches request path and http method matches request method
  def matches?(req)
    pattern.match(req.path) && req.request_method.downcase == http_method.to_s  
  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
  end
end

class Router
  attr_reader :routes

  def initialize
    # TODO: hash
    @routes = []
  end

  # append new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
  end

  # the router has methods corresponding to HTTP verbs
  # each method adds a Route object to the Router's `@routes`
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # should return the route that matches this request
  def match(req)
    @routes.find { |route| route.matches?(req) }
  end

  # find the requested URL
  # match it to the path regex of one Route object
  # ask the Route to instantiate the appropriate controller
  # call the appropriate method
  # else if no matched route, throw 404 instead of running
  def run(req, res)
  end
end
