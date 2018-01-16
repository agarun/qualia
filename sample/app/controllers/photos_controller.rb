require_relative "application_controller"

class PhotosController < ApplicationController
  def index
    render :index
  end
end
