require 'rails_helper'

describe ApplicationService, type: :service do
  let(:application_service) { ApplicationService.new }

  before :all do
    @services_service = ServicesService.new
    @user1 = create(:user)
    @profile1 = create(:profile, user: @user1)
    @service11 = build(:service, user: @user1)
    @service11.servicedata['description'] = 'first text'
    @services_service.update_text_search_column(@user1, @service11)
    @service11.save!
    @user2 = create(:user)
    @profile2 = create(:profile, user: @user2)
    @service21 = build(:service, user: @user2)
    @service21.servicedata['description'] = 'second description'
    @services_service.update_text_search_column(@user2, @service21)
    @service21.save!
    @service22 = build(:service, user: @user2)
    @service22.servicedata['description'] = 'third set of letters'
    @services_service.update_text_search_column(@user2, @service22)
    @service22.save!
  end

  describe '#search_results' do
    it 'finds no matches without query' do
      expect(application_service.search_results('')[:records].size).to eq(0)
    end
    it 'finds no matches with improper query' do
      expect(application_service.search_results('wtf')[:records].size).to eq(0)
    end
    it 'finds one match' do
      expect(application_service.search_results('first')[:records].size).to eq(1)
    end
    it 'finds two matches' do
      expect(application_service.search_results('text letter')[:records].size).to eq(2)
    end
    it 'finds three matches' do
      expect(application_service.search_results('text second letter')[:records].size).to eq(3)
    end
  end

  describe '#prepare_query' do
    it 'prepares query correctly' do
      expect(
        application_service.prepare_query('|dsj| JDfjv&&  hg')
      ).to eq(
        'to_tsquery(\'dsj | JDfjv | hg\')')
    end
  end

end