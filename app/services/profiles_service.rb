module ProfilesService

  def require_permission
    @profile = Profile.find(params[:id])
    if @profile.user_id != current_user.id
      redirect_to user_path(current_user),
                  notice: 'Editing of other\'s profile is forbidden.'
    end
  end

end