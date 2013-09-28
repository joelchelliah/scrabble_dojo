class AddBestTimeToMemos < ActiveRecord::Migration
  def change
  	add_column :memos, :best_time, :float
  end
end
