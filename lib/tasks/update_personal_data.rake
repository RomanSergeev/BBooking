namespace :profile do
  task update_personal_data: :environment do
    Profile.find_each(batch_size: 1000) do |profile|
      profile.personaldata['address'] = ""
      profile.save!
    end
  end
end