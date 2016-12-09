class AddPersonalDataToProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :personaldata, :jsonb
  end
end
