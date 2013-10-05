class AddPracticeDisabledToMemos < ActiveRecord::Migration
  def change
  	add_column :memos, :practice_disabled, :boolean, default: false
  end
end
