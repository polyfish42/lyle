require 'json'

class Flash
  def initialize(req)
    @last_res_cookies = find_flashes(req)
    @new_cookies = {}
    @flash_now = FlashNow.new
  end

  def find_flashes(req)
    if req.cookies['_rails_lite_app_flash']
      cookie = req.cookies['_rails_lite_app_flash']
      cookie = JSON.parse(cookie)
    else
      {}
    end
  end

  def [](key)
    key = key.to_s

    if @last_res_cookies[key]
      @last_res_cookies[key]
    elsif @flash_now.store[key]
      @flash_now.store[key]
    else
      @new_cookies[key]
    end
  end

  def []=(key, val)
    @new_cookies[key] = val
  end

  def now
    @flash_now
  end

  def store_flash(res)
    if @new_cookies.empty?
      res.set_cookie("_rails_lite_app_flash", {path: '/', value: {}.to_json})
    else
      res.set_cookie("_rails_lite_app_flash", {path: '/', value: @new_cookies.to_json})
    end
  end
end

class FlashNow
  attr_reader :store

  def initialize
    @store = {}
  end

  def [](key)
    @store[key]
  end

  def []=(key, value)
    @store[key] = value
  end
end
