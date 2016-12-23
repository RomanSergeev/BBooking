namespace :calendar do
  task set_default_calendars: :environment do
    User.find_each(batch_size: 1000) do |user|
      calendar = Calendar.new(user_id: user.id)
      calendar.save!
    end
  end
end