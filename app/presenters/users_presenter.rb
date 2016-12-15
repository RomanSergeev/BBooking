class UsersPresenter

  # @param[Profile] profile - our profile to be displayed
  def show_data(profile)
    json = profile.present? ? profile.personaldata : {}
    {
      json: json
    }
  end

end