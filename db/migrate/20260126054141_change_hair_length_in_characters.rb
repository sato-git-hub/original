class ChangeHairLengthInCharacters < ActiveRecord::Migration[7.2]
  def change
    change_column :characters, :hair_length, :string
  end
end
