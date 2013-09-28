class AddAcceptedWordsToMemos < ActiveRecord::Migration
  def change
  	add_column :memos, :accepted_words, :text
  end
end
