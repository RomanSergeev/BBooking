class Calendar < ApplicationRecord
  belongs_to :user
  has_many :services
end