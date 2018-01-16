class Static
  def initialize(app)
    @app = app
    @file_handler = FileHandler.new
  end

  def call(env)
    req = Rack::Request.new(env)
    file_path = req.path

    if will_serve_file?(file_path)
      @file_handler.call(env)
    else
      @app.call(env)
    end
  end

  private

  # is the asset in /public/*?
  def will_serve_file?(file_path)
    file_path.include?("/public")
  end
end

class FileHandler
  VALID_MIME_TYPES = {
    ".txt" => "text/plain",
    ".jpg" => "image/jpeg",
    ".zip" => "application/zip"
  }.freeze

  def call(env)
    res = Rack::Response.new
    static_file = static_file(env)

    if File.exist?(static_file)
      serve_file(static_file, res)
    else
      res.status = 404
      res.write("File not found")
    end

    res
  end

  private

  def serve_file(static_file, res)
    static_file_extension = File.extname(static_file)
    content_type = VALID_MIME_TYPES[static_file_extension]
    res["Content-type"] = content_type

    static_file_data = File.read(static_file)
    res.write(static_file_data) # serve to the browser
  end

  def static_file(env)
    req = Rack::Request.new(env)
    file_dir = File.dirname(__FILE__)
    File.join(file_dir, "..#{req.path}")
  end
end
