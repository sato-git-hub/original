class AddColumnToCharacters < ActiveRecord::Migration[7.2]
  def change
    add_column :characters, :bang_style, :string
  end
end
