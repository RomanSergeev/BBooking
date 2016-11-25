FactoryGirl.define do
  factory :user do
    email "factory@girl.com"
    password "encrypted..."
    password_confirmation "encrypted..."
  end
end