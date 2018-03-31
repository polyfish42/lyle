require 'rack'
require_relative '../lib/controller_base/router'
require_relative '../lib/model_base/db_connection'

router = Router.new
router.draw do
<<<<<<< HEAD
  # put your routes in here
=======
 #Routes go here
>>>>>>> c602cf683a80652d810e0cad97d8d99a5d44ada4
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
