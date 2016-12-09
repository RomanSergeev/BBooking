desc 'Add default value for full text search for existing records'
namespace :services do
  task set_initial_textsearch: :environment do
    Service.all.each do |service|
      service.textsearchable_index_col = (Profile.where(user_id: service.user_id)[0].personaldata['name'] || '') +
        ' ' + (service.servicedata['description'] || '')
      service.save!
    end
  end
end