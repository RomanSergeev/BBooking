require 'rails_helper'

describe Service, type: :model do

  describe '#defined_method' do
    it 'checks methods presence' do
      expect(create(:service)).to respond_to(:name, :duration, :description)
    end
  end

  describe 'name' do
    it 'raises exception on blank name' do
      expect{ create(:service, servicedata: '{}') }.to raise_error ActiveRecord::RecordInvalid
    end
  end

end