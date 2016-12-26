FactoryGirl.define do
  factory :service do
    user
    sequence(:servicedata) { |n| {name: "Name#{n}"} }
  end
end