class AddHealthDecayToMemos < ActiveRecord::Migration
  def change
  	add_column :memos, :health_decay, :datetime, default: Time.now
  end
end
