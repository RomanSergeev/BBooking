namespace :calendar do
  task set_default_calendars: :environment do
    User.all.each do |user|
      calendar = Calendar.new(user_id: user.id)
      calendar.save!
    end
  end
end