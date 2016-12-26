FactoryGirl.define do
  factory :service do
    user
    sequence(:id)
    sequence(:servicedata) { |n| {name: "Name#{n}"} }
  end
end