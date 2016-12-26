FactoryGirl.define do

  # doesn't work
  # def format_phone(number)
  #   str = number.to_s.rjust(10, '0')
  #   str[0, 3] + '-' + str[3, 3] + '-' + str[6, 4]
  # end

  factory :profile do
    user
    sequence(:personaldata) { |n| {name: "Name#{n}", phone: "111-222-3333"} }
  end
end
