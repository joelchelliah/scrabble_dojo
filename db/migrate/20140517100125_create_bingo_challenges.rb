class CreateBingoChallenges < ActiveRecord::Migration
  def change
    create_table :bingo_challenges do |t|
      t.string :mode
      t.integer :order
      t.text :tiles_list
      t.integer :level

      t.timestamps
    end

    add_index :bingo_challenges, :mode, unique: false
  end
end
