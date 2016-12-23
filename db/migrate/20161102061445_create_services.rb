class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.integer :user_id
      t.jsonb :servicedata

      t.timestamps
    end
    add_index :services, :user_id
  end
end
