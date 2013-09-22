class RenameTextToWordInWordEntries < ActiveRecord::Migration
  def change
  	remove_index :word_entries, column: :text

  	rename_column :word_entries, :text, :word

  	add_index :word_entries, :word, unique: true
  	add_index :word_entries, :letters, unique: false
  end
end
