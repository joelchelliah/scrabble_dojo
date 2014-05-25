class RenameOrderIdToMinRangeInBingoChallenges < ActiveRecord::Migration
  def change
    rename_column :bingo_challenges, :order_id, :min_range
  end
end
