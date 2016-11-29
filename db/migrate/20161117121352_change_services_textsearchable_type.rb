class ChangeServicesTextsearchableType < ActiveRecord::Migration[5.0]
  def change
    change_column :services, :textsearchable_index_col, :text
  end
end
