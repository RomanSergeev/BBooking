namespace :service do
  task set_default_values: :environment do
    Service.where(servicedata: nil).each do |service|
      service.servicedata = '{}'
      service.save!
    end
  end
end