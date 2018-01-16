require_relative "application_controller"
require_relative "../models/photo"
require_relative "../models/album"

class PhotosController < ApplicationController
  def index
    @photos = Photo.all
    render :index
  end

  def new
    @photo = Photo.new(
      photo_title: params[:photo][:photo_title],
      photo_url: params[:photo][:photo_url],
      user_id: rand(999),
      album_id: rand(999),
    )
  end
end
