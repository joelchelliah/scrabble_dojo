class AddUserIdToMemos < ActiveRecord::Migration
  def change
  	add_column :memos, :user_id, :integer

  	remove_index :memos, column: :name
  	
  	add_index :memos, [:user_id, :name], unique: true
  end
end
