class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :customer_id, null: false
      t.integer :service_id, null: false
      t.datetime :start_time, null: false
      t.integer :duration, default: 0
      t.timestamps
    end
  end
end
