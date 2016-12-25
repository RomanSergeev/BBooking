FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "factory#{n}@girl.com" }
    password 'some_password'
    password_confirmation 'some_password'
  end
end