require_relative "application_record"

class Photo < ApplicationRecord
  belongs_to :album
  has_one_through :user, :album, :user
  finalize!
end
