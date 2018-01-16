require_relative '../../lib/qualia/router'
require_relative '../app/controllers/photos_controller'

QualiaRouter = Router.new
QualiaRouter.draw do
  get Regexp.new("^/photos/new$"),
      PhotosController, :new
  get Regexp.new("^/$"),
      PhotosController, :index
  post Regexp.new("^/photos$"),
       PhotosController, :create
  get Regexp.new("^/photos/(?<photo_id>\\d+)$"),
      PhotosController, :show
  delete Regexp.new("^/photos/(?<photo_id>\\d+)$"),
         PhotosController, :destroy
end
