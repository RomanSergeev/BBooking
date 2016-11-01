namespace :user do
  task delete_users: :environment do
	  User.where(id > 2).each do |user|
		  user.destroy!
	  end
  end
end