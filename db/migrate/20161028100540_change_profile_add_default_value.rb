class ChangeProfileAddDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column_default :profiles, :personaldata, '{}'
  end
end
