class Service < ApplicationRecord
  include ActiveModel::Validations
  validates_with ServiceValidator
  belongs_to :user

  FIELDS = %w(
    name
    duration
    description
  )
  FIELDS.each do |field|
    define_method(field) do
      servicedata[field.to_s]
    end
  end

end
