require 'json'
require 'byebug'

class Session
  def initialize(req)
    @req = req
    @cookies = find_cookies(req)
  end

  def find_cookies(req)
    if req.cookies["_rails_lite_app"]
      cookie = req.cookies["_rails_lite_app"]
      JSON.parse(cookie)
    else
      {}
    end
  end

  def [](key)
    @cookies[key]
  end

  def []=(key, val)
    @cookies[key] = val
  end

  def store_session(res)
    res.set_cookie("_rails_lite_app", path: '/', value: @cookies.to_json)
  end
end
