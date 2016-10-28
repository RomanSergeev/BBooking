namespace :profile do
	task update_personal_data: :environment do
		Profile.all.each do |profile|
			profile.personaldata['address'] = ""
			profile.save!
		end
	end
end