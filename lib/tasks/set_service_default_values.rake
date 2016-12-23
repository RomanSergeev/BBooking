namespace :service do
  task set_default_values: :environment do
    Service.where(servicedata: nil).find_each(batch_size: 1000) do |service|
      service.servicedata = '{}'
      service.save!
    end
  end
end