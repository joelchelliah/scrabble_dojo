class UpdatePracticeDisabledInMemos < ActiveRecord::Migration
  def change
  	Memo.connection.execute("update memos set practice_disabled='false'")
  end
end
