require 'json'

class Session
  # @param [Rack::Request] an instance of a Rack::Request
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    lite_cookie = req.cookies['_rails_lite_app']
    @lite_cookie = lite_cookie ? JSON.parse(lite_cookie) : {}
  end

  # helper methods to get or set the session cookie content
  # due to `JSON.parse`, `@lite_cookie` is a Ruby hash in which
  # we can store keys and set values
  def [](key)
    @lite_cookie[key]
  end

  def []=(key, val)
    @lite_cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies (add to response --> store in client's browser)
  # ---
  # the path is root url so the cookie is available at every path
  # the value is a serialized *string* (i.e. JSON) of the cookie's data
  # `Rack::Response#set_cookie` handles setting the header
  def store_session(res)
    res.set_cookie('_rails_lite_app', {
      path: '/',
      value: @lite_cookie.to_json
    })
  end
end
