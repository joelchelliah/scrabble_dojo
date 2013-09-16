class ChangeDefaultForMemosHealthDecay < ActiveRecord::Migration
  def change
  	change_column :memos, :health_decay, :datetime, default: nil
  end
end
