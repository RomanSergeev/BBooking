class ProfileValidator < ActiveModel::Validator
  NAME_REGEX = /\A[A-Z][A-Za-z0-9 ]*\z/
  PHONE_REGEX = /\A\d{3}-\d{3}-\d{4}\z/

  def validate(record)
    jsonb = record.personaldata
    unless NAME_REGEX.match(jsonb['name'])
      record.errors.add(:name, 'Name should start from big letter.')
    end
    unless PHONE_REGEX.match(jsonb['phone'])
      record.errors.add(:phone, 'Phone should be digital like XXX-XXX-XXXX.')
    end
  end

end