require 'rails_helper'

describe User, type: :model do

  describe 'validation' do
    it 'raises error on invalid email' do
      expect{create(:user, email: 'abcabc')}.to raise_error(ActiveRecord::RecordInvalid, /email/i)
    end
  end

  # associations

  describe 'calendar association' do
    it 'checks calendar presence' do
      association = User.reflect_on_association(:calendar)
      expect(association.macro).to eq(:has_one)
    end
  end

  describe 'profile association' do
    it 'checks profile presence' do
      association = User.reflect_on_association(:profile)
      expect(association.macro).to eq(:has_one)
    end
  end

end