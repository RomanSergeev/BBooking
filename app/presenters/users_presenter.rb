class UsersPresenter

  # @param[User] user whose profile to be displayed
  # @param[User] current_user from Devise
  def show_data(user, current_user)
    profile_is_present = user.profile.present?
    json = profile_is_present ? user.profile.personaldata : {}
    user_is_owner = user.id == current_user.id
    {
      user: user,
      user_is_owner: user_is_owner,
      profile: user.profile,
      profile_is_present: profile_is_present,
      json: json
    }
  end

end