require_relative '../db/sample'
require_relative "../config/routes"
require_relative "../../lib/qualia/static"
require_relative "../../lib/qualia/show_exceptions"
require "rack"

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  QualiaRouter.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use Static
  use ShowExceptions
  run app
end.to_app

Rack::Server.start(
  app: app,
  Port: 3000
)
