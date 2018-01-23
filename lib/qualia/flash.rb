require 'json'

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
