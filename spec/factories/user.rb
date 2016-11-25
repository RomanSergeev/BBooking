FactoryGirl.define do
  factory :user do
    email "factory@girl.com"
    password "some_password"
    password_confirmation "some_password"
  end
end