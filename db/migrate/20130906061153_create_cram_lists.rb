class CreateCramLists < ActiveRecord::Migration
  def change
    create_table :cram_lists do |t|
      t.string :name
      t.text :hints
      t.text :word_list

      t.timestamps
    end
  end
end
