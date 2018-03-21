require 'rack'
require_relative '../lib/controller_base/router'
require_relative '../app/controllers/cats_controller'
require_relative '../lib/model_base/db_connection'

router = Router.new
router.draw do
 #Routes go here
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
