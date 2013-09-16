class AddIndexToCramListsName < ActiveRecord::Migration
  def change
  	add_index :cram_lists, :name, unique: true
  end
end
