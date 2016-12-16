class ProfilesService

  def new_profile(current_user, params = nil)
    Profile.new(
      user_id: current_user.id,
      personaldata:
        params.nil? ?
          {name: '', phone: ''} :
          params[:profile]
    )
  end

  def find_profile(id)
    Profile.find(id)
  end

end