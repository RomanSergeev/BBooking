class OrderValidator < ActiveModel::Validator

  def validate(record)
    record.errors.add(:customer_is_owner, 'One can\'t order own services') if
      record.customer_id == Service.find(record.service_id).user_id
  end

end