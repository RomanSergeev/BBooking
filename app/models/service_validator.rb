class ServiceValidator < ActiveModel::Validator

  def validate(record)
    jsonb = record.servicedata
    if jsonb['name'].to_s == ''
      record.errors.add(:name, 'Name shouldn\'t be blank.')
    end
  end

end