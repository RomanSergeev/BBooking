require 'rails_helper'

describe Calendar, type: :model do

  describe 'creation' do
    it 'raises invalid statement' do
      expect{ create(:calendar, user_id: nil) }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

  # associations

  describe 'user association' do
    it 'checks user presence' do
      association = Calendar.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

end
