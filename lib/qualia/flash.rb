require 'json'

# Keep in mind that items stored in Flash exhibit two different types of behaviors;
# some persist to the next request, while others disappear with the controller.
# It might be a good idea to store these items differently.

# Cookies store not only a given name and domain, but also the specific path of the request.
# Make sure the cookie's path is set to / like the session cookie. This will ensure that we're
# always dealing with the same cookie when inspecting and resetting the flash store.

class Flash
  attr_reader :now

  # `now` data only lives for one response cycle (only for the
  # current view being rendered) and will not persist to the next request
  # because it gets overwritten on every instantiation of `Flash`.
  # `flash` data will persist for this request and the next
  # request by living in the `@now` ivar on the next instantiation,
  # but is reset after two response cycles.
  def initialize(req)
    flash_cookie = req.cookies['_rails_lite_app_flash']

    @now = flash_cookie ? JSON.parse(flash_cookie) : {}
    @flash = {}
  end

  # persisting the flash cookie but flushing the now data
  # is enabled by checking the `@now` ivar first
  def [](notice)
    @now[notice.to_s] || @now[notice.to_sym] || @flash[notice.to_s]
  end

  def []=(notice, message)
    @flash[notice.to_s] = message
  end

  def store_flash(res)
    res.set_cookie(
      '_rails_lite_app_flash',
      path: '/',
      value: @flash.to_json
    )
  end
end
