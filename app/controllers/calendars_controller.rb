class CalendarsController < ApplicationController
  layout 'user'

  def show
    set_services
    user = @users_service.find_user(params)
    require_profile?(user) or return
    @timeline_data = @calendars_service.get_data_for_timeline(user, false)
    init_presenter
    render 'show', locals: { view_data: @calendars_presenter.show_data(user) }
  end

  def edit
    set_services
    user = @users_service.find_user(params)
    require_permission?(user) or return
    require_profile?(user) or return
    init_presenter
    render 'edit', locals: { view_data: @calendars_presenter.edit_data(user.calendar) }
  end

  def update
    set_services
    user = @users_service.find_user(params)
    require_permission?(user) or return
    require_profile?(user) or return
    json = params[:calendar][:preferences]
    data_is_correct_for?(json) or return
    @calendars_service.update_preferences_border_values(json)
    user.calendar.preferences = json
    if user.calendar.update(calendar_params)
      redirect_to user_calendar_path
    else
      init_presenter
      render 'edit', locals: { view_data: @calendars_presenter.edit_data(user.calendar) }
    end
  end

  private

  def require_permission?(user)
    if user.id != current_user.id
      redirect_to user_path(user),
                  notice: 'Editing or deleting of other\'s calendar is forbidden.'
      return false
    end
    true
  end

  def data_is_correct_for?(json)
    unless @calendars_service.check_for_correct_calendar_data?(json)
      redirect_to user_path(current_user.id),
                  notice: 'Parameters for calendar seem to be incorrect.'
      return false
    end
    true
  end

  def set_services
    @calendars_service = CalendarsService.new
    @users_service = UsersService.new
  end

  def init_presenter
    @calendars_presenter = CalendarsPresenter.new(current_user.id)
  end

  def calendar_params
    params.require(:calendar).permit(:preferences)
  end

end