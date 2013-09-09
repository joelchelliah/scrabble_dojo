class AddIndexToCramListsName < ActiveRecord::Migration
  def change
  	add_index :memos, :name, unique: true
  end
end
