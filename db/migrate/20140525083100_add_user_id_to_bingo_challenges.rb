class AddUserIdToBingoChallenges < ActiveRecord::Migration
  def change
    add_column :bingo_challenges, :user_id, :integer
    
    add_index :bingo_challenges, :user_id, unique: false
  end
end
