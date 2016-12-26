require 'rails_helper'

describe ServicesService, type: :service do
  let(:services_service) { ServicesService.new }
  let(:user) { create(:user) }

  describe '#new_service' do
    context 'without_permitted_params' do
      it 'returns new service' do
        expect(services_service.new_service(user.id)).to be_a_new(Service).with(user_id: user.id)
      end
    end
    context 'with permitted_params' do
      it 'returns new service' do
        # expect(services_service.new_service(user.id, params)).to be_a_new(Service).with(user_id: user.id)
      end
    end
  end

  describe '#update_text_search_column' do
    it 'records new text_search_column' do
      service_name = 'some name'
      description = 'some description'
      profile_name = 'Username'
      service = build(:service)
      service.servicedata['name'] = service_name
      service.servicedata['description'] = description
      service.save!
      profile = build(:profile, user: service.user)
      profile.personaldata['name'] = profile_name
      profile.save!
      services_service.update_text_search_column(service.user, service)
      expect(service.textsearchable_index_col).to eq(
        profile_name + ' ' +
        service_name + ' ' +
        description
      )
    end
  end

  describe '#booking_is_available?' do
    it 'returns true' do
      provider = create(:user)
      service = create(:service, user: provider)
      expect(services_service.booking_is_available?(
        user,
        service,
        DateTime.now + 6.hours + 1.minute)
      ).to be_truthy
    end
    it 'returns false' do
      provider = create(:user)
      service = create(:service, user: provider)
      expect(services_service.booking_is_available?(
        user,
        service,
        DateTime.now + 6.hours - 1.minute)
      ).to be_falsy
    end
  end

  describe '#booking_performed?' do
    it 'returns true' do
      provider = create(:user)
      service = create(:service, user: provider)
      expect(services_service.booking_performed?(
        user,
        service,
        DateTime.now + 6.hours + 1.minute)
      ).to be_truthy
    end
    it 'returns false' do
      provider = create(:user)
      service = create(:service, user: provider)
      expect(services_service.booking_performed?(
        user,
        service,
        DateTime.now + 6.hours - 1.minute)
      ).to be_falsy
    end
  end

  describe '#format_booking_date' do
    it 'formats correct output' do
      day = Date.today
      hours = '12'
      minutes = '5'
      expect(services_service.format_booking_date(day, hours, minutes)).to eq(
        Date.today +
        12.hours +
        5.minutes
      )
    end
  end
end