require_relative "application_record"

class User < ApplicationRecord
  has_many :albums

  finalize!
end
