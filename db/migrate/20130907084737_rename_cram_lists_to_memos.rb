class RenameCramListsToMemos < ActiveRecord::Migration
  def change
    rename_table :cram_lists, :memos
  end
end
