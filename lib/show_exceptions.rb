require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  # the app *must* respond to `#call`
  def call(env)
    app.call(env)
  rescue => error
    render_exception(error)
  end

  private

  def render_exception(error)
    html_error_template_path = File.dirname(__FILE__) + "/templates/rescue.html.erb"
    html_error_template = File.read(html_error_template_path)
    # use Kernel#binding to make instance methods available in the ERB view
    rescue_body = ERB.new(html_error_template).result(binding)

    [
      '500',
      {
        'Content-type' => 'text/html'
      },
      rescue_body
    ]
  end

  def get_backtrace(error)
    error.backtrace.slice(0, 2)
  end
end
