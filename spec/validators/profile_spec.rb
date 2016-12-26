require 'rails_helper'

describe ProfileValidator, type: :validator do

  before :each do
    @user = create(:user)
  end

  describe '#validate' do
    context 'when name is incorrect' do
      context 'when name starts from small letter' do
        it 'checks name error presence' do
          profile = build(:profile, user: @user)
          profile.personaldata['name'] = 'smallLetterStarted'
          profile.valid?
          expect(profile.errors[:name].count).to eq(1)
        end
      end
      context 'when name is blank' do
        it 'checks name error presence' do
          profile = build(:profile, user: @user)
          profile.personaldata['name'] = ''
          profile.valid?
          expect(profile.errors[:name].count).to eq(1)
        end
      end
      context 'when name contains wrong symbols' do
        it 'checks name error presence' do
          profile = build(:profile, user: @user)
          profile.personaldata['name'] = 'Name_with_wrong_symbols'
          profile.valid?
          expect(profile.errors[:name].count).to eq(1)
        end
      end
    end

    context 'when phone is incorrect' do
      context 'when phone is blank' do
        it 'checks phone error presence' do
          profile = build(:profile, user: @user)
          profile.personaldata['phone'] = ''
          profile.valid?
          expect(profile.errors[:phone].count).to eq(1)
        end
      end
      context 'when phone doesn\'t match regex' do
        it 'checks phone error presence' do
          profile = build(:profile, user: @user)
          profile.personaldata['phone'] = '123-456-78900'
          profile.valid?
          expect(profile.errors[:phone].count).to eq(1)
        end
      end
    end
  end

end
