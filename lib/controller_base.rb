require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    !!@already_built_response
  end
  
  # helper method to prohibit double renders/redirects
  # and to set @already_built_response otherwise
  def set_response_status
    raise if already_built_response?
    @already_built_response = true
  end
  
  # set the response status code and header
  # ---
  # set the 'Location' field of the response header to the redirect url 
  # set the response status code to 302 Found (default is 200)
  def redirect_to(url)
    res.location = url
    res.status = 302
    set_response_status
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  # ---
  # populate the HTTP response header with the content type (e.g. 'text/html')
  # append the `content` string to the response body 
  # (& update Content-Length in the HTTP response header)
  def render_content(content, content_type)
    res['Content-Type'] = content_type
    res.write(content)
    set_response_status
  end
  
  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  # ---
  # use controller and template names to construct paths to template files
  # read the template file in via `File.read`
  # create a new ERB template from the contents
  # evaluate the ERB template, using binding to capture the controller's instance variables.
  #   - `binding` is a Kernel method that packages the environment bindings (vars, methods, self) 
  #   - (i.e. current context) that are in-scope at call location, & stores them
  #   - in a Binding object to make them available in another context
  #   ---
  #   - in our use case, every controller inherits from `ControllerBase`, so a call to
  #   - `.result(binding)` on the ERB Object will package up the bindings (ivars, etc.)
  #   - in the current controller's context and allow access to the context 
  #   - from within any ERB tags
  # pass the result to #render_content with a content_type of text/html
  def render(template_name)
    controller_name = self.class.to_s.underscore
    view_contents = File.read("views/#{controller_name}/#{template_name}.html.erb")
    view_contents_with_context = ERB.new(view_contents).result(binding)
    render_content(view_contents_with_context, "text/html")
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

