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
    set_calendar
  end

  def update
    find_user
    require_permission
    require_profile
    set_calendar
    @user.calendar.preferences = params[:calendar][:preferences]
    if @user.calendar.update(calendar_params)
      redirect_to user_calendar_path
    else
      render 'edit'
    end
  end

  private

  def calendar_params
    params.require(:calendar).permit(:preferences)
  end

end