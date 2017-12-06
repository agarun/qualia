require 'rack'

app = proc do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  
  # `#write(string)` appends string to body and updates content length
  res['Content-Type'] = 'text/html'
  res.write(req.path) 
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)