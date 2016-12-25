FactoryGirl.define do
  factory :calendar do
    user
    preferences '{serving_start: "540", break_start: "720", break_finish: "780", serving_finish: "1080"}'
  end
end
