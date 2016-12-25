FactoryGirl.define do
  factory :order do
    customer_id 1
    service_id 1
    duration 1
    rest_time 1
    start_time { 1.hour.ago }
  end
end
