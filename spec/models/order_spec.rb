require 'rails_helper'

describe Order, type: :model do
  describe 'incorrect orders' do
    it 'raises exception on provider and customer ids equal' do
      service = create(:service)
      order = build(:order) do |order|
        order.service_id = service.id
        order.customer_id = service.user_id
      end
      expect{ order.save! }.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
