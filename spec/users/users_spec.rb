require 'rails_helper'

describe 'User' do

  describe 'validation' do
    it 'should raise error on invalid email' do
      expect{create(:user, email: "abcabc")}.to raise_error(ActiveRecord::RecordInvalid, /email/i)
    end
  end

end