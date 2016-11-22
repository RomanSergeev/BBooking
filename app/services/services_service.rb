module ServicesService
  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
    @provider = User.preload(:profile).find(@service.user_id)
  end

  def require_permission(provider)
    if provider.id != current_user.id
      redirect_to user_path(current_user),
                  notice: 'Editing or deleting of other\'s service is forbidden.'
    end
  end

end