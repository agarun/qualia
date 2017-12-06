require 'json'

# Keep in mind that items stored in Flash exhibit two different types of behaviors; 
# some persist to the next request, while others disappear with the controller. 
# It might be a good idea to store these items differently.

# Cookies store not only a given name and domain, but also the specific path of the request. 
# Make sure the cookie's path is set to / like the session cookie. This will ensure that we're 
# always dealing with the same cookie when inspecting and resetting the flash store.

class Flash
  attr_reader :now
  
  # if the cookie already exists, consider it `flash.now` (@now)
  # @flash will always be stored in `store_flash` so it persists, but @now doesn't
  def initialize(req)
    flash_cookie = req.cookies['_rails_lite_app_flash']
    
    if flash_cookie
      @now = JSON.parse(flash_cookie)
    else
      @now = {}
    end
    
    @flash = {}
  end
  
  def [](notice)
    @now[notice.to_sym] || @flash[notice.to_sym] 
  end
  
  def []=(notice, message)
    @flash[notice.to_sym] = message
  end
  
  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', {
      path: '/',
      value: @flash.to_json
    })
  end
end
