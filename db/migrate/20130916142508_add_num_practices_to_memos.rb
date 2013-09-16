class AddNumPracticesToMemos < ActiveRecord::Migration
  def change
  	add_column :memos, :num_practices, :integer, default: 0
  end
end
