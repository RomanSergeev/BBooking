require 'rails_helper'

describe CalendarsService, type: :service do
  let(:calendars_service) { CalendarsService.new }

  before :all do
    services_service = ServicesService.new
    duration = 30
    @customer = create(:user)
    @provider = create(:user)
    @otherguy = create(:user)
    @service = build(:service, user: @provider)
    @service.servicedata[:duration] = duration
    @service.save!
    performed = services_service.booking_performed?(
      @customer,
      @service,
      Date.today + 6.hours + 14.hours + 25.minutes
    )
    # Order.create(
    #   customer_id: @customer.id,
    #   service_id: @service.id,
    #   start_time: ,
    #   duration: duration
    # )
  end

  # NOT PASSING
  describe '#get_data_for_timeline' do
    context 'when user is a provider' do
      it 'returns hash for provider' do
        hash = calendars_service.get_data_for_timeline(@provider, true)
        hash[:ordered_at_me].each_row do |tuple|
          puts tuple
        end
        expect(hash[:user]).to eq(@provider)
        expect(hash[:my_orders].ntuples).to eq(0)
        expect(hash[:ordered_at_me].ntuples).to eq(1)
        expect(hash[:free_time_intervals]).to eq(
          IntervalSet.new([540..720, 780..865, 895..1080])
        )
      end
    end
  end
end