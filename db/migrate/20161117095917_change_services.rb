class ChangeServices < ActiveRecord::Migration[5.0]
  def change
    change_column :services, :user_id, :integer
  end
end
