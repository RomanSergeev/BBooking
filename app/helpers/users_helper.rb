module UsersHelper

  def format_name(service)
    service.servicedata && service.servicedata['name'] || ''
  end

  def format_duration(service)
    (service.servicedata && service.servicedata['duration'] || '') + ' minutes'
  end

end
