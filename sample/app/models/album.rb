require_relative "application_record"

class Album < ApplicationRecord
  belongs_to :user
  has_many :photos

  finalize!
end
