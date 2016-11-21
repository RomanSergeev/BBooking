namespace :nmspc do
  task task: :environment do
    Service.where(servicedata: nil).each do |service|
      service.servicedata = '{}'
      service.save!
    end
  end
end