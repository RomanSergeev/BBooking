desc 'Add default value for full text search for existing records'
namespace :services do
  task set_initial_textsearch: :environment do
    Service.all.each do |service|
      next unless service.servicedata && service.servicedata['description']
      description = service.servicedata['description']
      service.textsearchable_index_col = ApplicationRecord.connection.execute("SELECT to_tsvector('" + description + "');")[0]['to_tsvector']
      service.save!
    end
  end
end