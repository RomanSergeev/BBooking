class Order < ApplicationRecord
  validates_with OrderValidator
end
