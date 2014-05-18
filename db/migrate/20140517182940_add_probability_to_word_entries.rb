class AddProbabilityToWordEntries < ActiveRecord::Migration
  def change
    add_column :word_entries, :probability, :decimal, default: 0

    add_index :word_entries, :probability, unique: false
  end
end
