class RenameWordsToWordEntries < ActiveRecord::Migration
  def change
  	rename_table :words, :word_entries
  end
end
