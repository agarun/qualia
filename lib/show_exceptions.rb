require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  # a Rack middleware must respond to `#call`
  def call(env)
    app.call(env)
  rescue => error
    render_exception(error)
  end

  private

  def render_exception(error)
    dir_path = File.dirname(__FILE__)
    html_error_template_path = File.join(dir_path, "/templates/rescue.html.erb")
    html_error_template = File.read(html_error_template_path)

    # use Kernel#binding to make instance methods available in the ERB view
    rescue_body = ERB.new(html_error_template).result(binding)

    [
      '500',
      {
        'Content-type' => 'text/html'
      },
      [
        rescue_body
      ]
    ]
  end

  def stack_trace_top(error)
    error.backtrace.first.split(':')
  end

  def source_line_number(error)
    stack_trace_top(error)[1].to_i
  end

  def error_source_file(error)
    stack_trace_top(error).first
  end

  def open_source_lines(error)
    File.open(
      error_source_file(error),
      'r'
    ).readlines
  end

  def get_source(error)
    format_source_lines(
      open_source_lines(error),
      source_line_number(error)
    )
  end

  def format_source_lines(source_lines, source_line_number)
    # show preceding lines if possible
    start_line_number = [0, source_line_number - 3].max

    formatted_source_lines = []
    (start_line_number..start_line_number + 6).each do |line_number|
      formatted_source_lines << [line_number, source_lines[line_number]]
    end
    formatted_source_lines
  end
end
