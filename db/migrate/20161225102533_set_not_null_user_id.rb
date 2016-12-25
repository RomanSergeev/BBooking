class SetNotNullUserId < ActiveRecord::Migration[5.0]
  def change
    change_column_null :calendars, :user_id, false
    change_column_null :profiles, :user_id, false
  end
end
