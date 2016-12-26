require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the CalendarsHelper. For example:
#
# describe CalendarsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe CalendarsHelper, type: :helper do
  let(:dummy_class) { Class.new { include CalendarsHelper } }

  describe '#width' do
    it 'returns 100' do
      expect(dummy_class.width(dummy_class::TIMELINE_PERCENT)).to eq(100)
    end
  end
end
