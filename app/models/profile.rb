class Profile < ApplicationRecord
  include ActiveModel::Validations
  validates_with ProfileValidator
  belongs_to :user

  # define custom getter methods like :name, :phone etc for accessing via form_for @profile
  FIELDS = %w(
    name
    phone
    country
    city
    address
  )
  FIELDS.each do |field|
    define_method(field) do
      personaldata[field.to_s]
    end
  end

end
