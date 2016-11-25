require 'rails_helper'

describe 'User' do
  it 'should check simplest thing ever' do
    user = create(:user)
    expect(user.greater(7)).to eq(false)
  end

  describe 'validation' do
    it 'should raise error on invalid email' do
      expect{create(:user, email: "abcabc")}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end