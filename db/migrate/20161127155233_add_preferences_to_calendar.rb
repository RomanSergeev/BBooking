class AddPreferencesToCalendar < ActiveRecord::Migration[5.0]
  def change
    add_column :calendars, :preferences, :jsonb, null: false, default: '{}'
  end
end
