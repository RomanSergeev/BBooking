class CalendarsController < ApplicationController
  include CalendarsService
  include UsersService
  layout 'user'

  def show
    find_user
    puts 'entering calendars/show'
    require_profile?(@user) or return
    init_presenter
    set_calendar
    render 'show', locals: { view_data: @calendars_presenter.show_data(@user) }
  end

  def edit
    find_user
    require_permission
    require_profile?(@user) or return
    init_presenter
    render 'edit', locals: { view_data: @calendars_presenter.edit_data(@user.calendar) }
  end

  def update
    find_user
    require_permission
    require_profile?(@user) or return
    json = params[:calendar][:preferences]
    if check_for_correct_calendar_data?(json)
      json['serving_start'] = json['serving_start'].to_i - 1
      json['break_finish'] = json['break_finish'].to_i - 1
      @user.calendar.preferences = json
      if @user.calendar.update(calendar_params)
        redirect_to user_calendar_path
      else
        init_presenter
        render 'edit', locals: { view_data: @calendars_presenter.edit_data(@user.calendar) }
      end
    end
  end

  private

  def calendar_params
    params.require(:calendar).permit(:preferences)
  end

end