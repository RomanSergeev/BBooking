class ServicesPresenter

  # @param [jsonb] service_data
  def form_data(service_data)
    {
      name: service_data['name'],
      duration: service_data['duration'] || 15,
      description: service_data['description'],
      rest_time: service_data['rest_time'] || 5
    }
  end

  # @param [jsonb] service_data
  def show_data(service_data)
    description = service_data['description']
    if not description.present? or description.empty?
      description = 'No description provided.'
    end
    {
      name: service_data['name'],
      duration: service_data['duration'],
      description: description
    }
  end

end