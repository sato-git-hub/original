class CreateCharacters < ActiveRecord::Migration[7.2]
  def change
    create_table :characters do |t|
    t.string  :hair_color
    t.string  :hair_style
    t.string  :hair_type
    t.integer :hair_length
    t.string  :skin_tone
    t.integer :height
    t.string  :body_type
    t.string  :body_frame
    t.string  :personal_color
    t.integer :age
    t.string  :sex
    t.string  :eye_color
    t.string :eye_shape
    t.string  :mbti
    t.boolean :glasses
    t.string :face_type 
    t.string :face_shape
    t.timestamps
    end
  end
end
