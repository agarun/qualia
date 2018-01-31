require_relative "application_controller"
require_relative "../models/photo"
require_relative "../models/user"
require_relative "../models/album"

class PhotosController < ApplicationController
  def index
    @photos = Photo.all
    render :index
  end

  def new
    render :new
  end

  def create
    @photo = Photo.new(
      photo_title: params['photos']['photo_title'],
      photo_url: params['photos']['photo_url'],
      user_id: User.all.sample.id,
      album_id: Album.all.sample.id
    )

    if @photo.save
      @photos = Photo.all
      render :index
    else
      render ['error: invalid fields'], status: 422
    end
  end
end
