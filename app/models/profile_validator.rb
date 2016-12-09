class ProfileValidator < ActiveModel::Validator
  NAME_REGEX = /\A[A-Z][A-Za-z ]*\z/
  PHONE_REGEX = /\A\d{3}-\d{3}-\d{4}\z/

  def validate(record)
    jsonb = record.personaldata
    unless NAME_REGEX.match(jsonb['name'])
      record.errors[:name] = 'Name should start from big letter & contain only letters.'
    end
    unless PHONE_REGEX.match(jsonb['phone'])
      record.errors[:phone] = 'Phone should be digital like XXX-XXX-XXXX.'
    end
  end
end