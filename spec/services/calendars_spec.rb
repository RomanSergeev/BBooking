require 'rails_helper'

describe CalendarsService, type: :service do
  let(:calendars_service) { CalendarsService.new }

  before :all do
    duration = 30
    @customer = create(:user)
    @provider = create(:user)
    @otherguy = create(:user)
    @service = create(:service, user: @provider)
    @service.servicedata['duration'] = duration
    Order.create(
      customer_id: @customer.id,
      service_id: @service.id,
      start_time: Date.today + 6.hours + 14.hours + 25.minutes,
      duration: duration
    )
  end

  describe '#get_data_for_timeline' do
    context 'when user is a provider' do
      it 'returns hash for provider' do
        hash = calendars_service.get_data_for_timeline(@provider, true)
        expect(hash[:user]).to eq(@provider)
        expect(hash[:my_orders]).to be_empty
        expect(hash[:ordered_at_me]).not_to be_empty
        expect(hash[:free_time_intervals]).to eq(
          IntervalSet.new([540..720, 780..865, 895..1080])
        )
      end
    end
  end
end