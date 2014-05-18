class RenameOrderToOrderIdInBingoChallenges < ActiveRecord::Migration
  def change
    rename_column :bingo_challenges, :order, :order_id
  end
end
