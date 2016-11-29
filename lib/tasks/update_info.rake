namespace :profile do
  task update_info: :environment do
    User.all.each do |user|
      unless Profile.exists?(user_id: user.id)
        profile = Profile.new
        profile.user_id = user.id # Correct or not?
        profile.personaldata = '{"name": "", "phone": "", "country": "", "city": "", "visibleflags": 7}'
        profile.save!
      end
    end
  end
end