class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :text
      t.string :letters
      t.integer :length
      t.string :first_letter

      t.timestamps
    end
    add_index :words, :text, unique: true
  end
end
