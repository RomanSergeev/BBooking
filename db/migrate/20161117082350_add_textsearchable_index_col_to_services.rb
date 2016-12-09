class AddTextsearchableIndexColToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :textsearchable_index_col, :tsvector
  end
end
