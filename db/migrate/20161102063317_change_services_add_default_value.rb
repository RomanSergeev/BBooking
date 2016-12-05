class ChangeServicesAddDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column_default :services, :servicedata, '{}'
  end
end
