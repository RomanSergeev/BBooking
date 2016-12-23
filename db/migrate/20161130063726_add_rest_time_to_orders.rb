class AddRestTimeToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :rest_time, :integer, default: 5
  end
end
