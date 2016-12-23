class CreateCalendars < ActiveRecord::Migration[5.0]
  def change
    create_table :calendars do |t|
      t.belongs_to :user
      t.timestamps
    end
  end
end
