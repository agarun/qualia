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

  # instantiates an instance of the controller class
  # calls the *controller's* action via `ControllerBase#invoke_action`
  def run(req, res)
    if matches?(req)
      controller_instance = controller_class.new(req, res, route_params(req))
      controller_instance.invoke_action(action_name)
    else
      # extra precaution! won't be hit if `Router#run` is used
      res.status = 404
      res.write("No route matches for #{http_method} on #{controller_class}")
    end
  end
  
  private
  
  def route_params(req)
    params = {}
    match_data = pattern.match(req.path)
    match_data.names.each { |key| params[key] = match_data[key] }
    params
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # append new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # evaluate the proc in the context of the instance (syntactic sugar)
  # e.g. routes.draw { get Regexp.new("^/cats$"), Cats2Controller, :index }
  # the contents of the proc will be able to call `Router#get` method with its
  # arguments because `instance_eval` changes the scope inside the block
  def draw(&proc)
    self.instance_eval(&proc)
  end

  # the router has methods corresponding to HTTP verbs
  # each method adds a Route object to the Router's `@routes`
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # return the route that matches this request
  def match(req)
    @routes.find { |route| route.matches?(req) }
  end

  # call #run on the first matching route
  # ---
  # find the requested URL
  # match it to the path regex of one Route object
  # ask the Route to instantiate the appropriate controller
  # and call the appropriate method corresponding to the action
  # else if no matched route, throw 404 & add message
  def run(req, res)
    first_matched_route = match(req)
    
    if first_matched_route
      first_matched_route.run(req, res)
    else
      res.status = 404
      res.write("No route matches for #{req.request_method} for #{req.path}")
    end
  end
end
