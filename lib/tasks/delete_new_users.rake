namespace :user do
  task delete_users: :environment do
    User.where(id > 2).find_each(batch_size: 1000) do |user|
      user.destroy!
    end
  end
end