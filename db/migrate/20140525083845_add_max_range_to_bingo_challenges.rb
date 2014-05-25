class AddMaxRangeToBingoChallenges < ActiveRecord::Migration
  def change
    add_column :bingo_challenges, :max_range, :integer
  end
end
