namespace :order do
  task update_rest_times: :environment do
    Order.all.each do |order|
      # Bad practice of many queries but task is passed only once
      service = Service.find(order.service_id)
      user = User.find(service.user_id)
      json = Calendar.where(user_id: user.id)[0].preferences
      rest_time = json['rest_time'] || 5
      order.rest_time = rest_time
      order.save!
    end
  end
end