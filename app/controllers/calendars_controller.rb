class CalendarsController < ApplicationController
  include CalendarsService
  MINUTES_IN_DAY = 1440
  TIMELINE_PERCENT = 1440 / 100.0
  layout 'user'

  def show
    find_user
    require_profile
    set_calendar
  end

  def edit
    find_user
    require_permission
    require_profile
  end

  def update
    find_user
    require_permission
    require_profile
    json = params[:calendar][:preferences]
    if check_for_correct_calendar_data?(json)
      @user.calendar.preferences = json
      if @user.calendar.update(calendar_params)
        redirect_to user_calendar_path
      else
        render 'edit'
      end
    end
  end

  private

  def calendar_params
    params.require(:calendar).permit(:preferences)
  end

end