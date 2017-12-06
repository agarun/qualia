require 'erb'

class ShowExceptions
  attr_reader :app
  
  def initialize(app)
    @app = app 
  end

  def call(env)
    req = Rack::Request.new(env)
    
    begin
      
    rescue
      
    end
    
  end

  private

  def render_exception(e)
  end

end
