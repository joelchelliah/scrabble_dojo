require 'spec_helper'

describe MemosHelper do
  before { @memo = Memo.new(name: "A3", hints: "", word_list: "ABC", health_decay: Time.now - 10.days) }

	describe "health" do	
		it "calculates the amount of health based on date of last revision" do
			helper.health(@memo).should == 70
		end

		it "should not let the health go below 1" do
			@memo.health_decay = Time.now - 100.days
			helper.health(@memo).should == 1
		end

		it "should not let the health go above 100" do
			@memo.health_decay = Time.now + 100.days
			helper.health(@memo).should == 100
		end
	end

	describe "health bar" do
		it "should draw a yellow health bar for health below 75" do
			helper.health_bar(@memo).should =~ /progress-warning/
		end

		it "should draw a red health bar for health below 25" do
			@memo.health_decay = Time.now - 30.days
			helper.health_bar(@memo).should =~ /progress-danger/
		end

		it "should draw a green health bar for health above 75" do
			@memo.health_decay = Time.now - 5.days
			helper.health_bar(@memo).should =~ /progress-success/
		end
	end

	describe "show health" do
		it "should display the health% in yellow if health is below 75" do
			helper.show_health.should =~ /text-warning.*%/
		end

		it "should display the health% in red if health is below 25" do
			@memo.health_decay = Time.now - 30.days
			helper.show_health.should =~ /text-error.*%/
		end

		it "should display the health% in green if health is above 75" do
			@memo.health_decay = Time.now - 5.days
			helper.show_health.should =~ /text-success.*%/
		end
	end

	describe "show word count" do
		it "should display the number of words in the memo's word list" do
			helper.show_word_count(@memo).should == 1

			@memo.word_list = "ABC\nADL\nAGA"
			helper.show_word_count(@memo).should == 3
		end
	end

	describe "show total word count" do
		before do
				@memo.word_list = "ABC\nADL\nAGA"
				@memos = [@memo, @memo, @memo]
			end

		it "should display the total number of words from all the memos' word list" do
			helper.show_total_word_count.should == 9
		end
	end

	describe "show total practice count" do
		before do
				@memo.num_practices = 5
				@memos = [@memo, @memo, @memo]
			end

		it "should display the total number of practices from all the memos" do
			helper.show_total_practice_count.should == 15
		end
	end

	describe "show average health" do
		before do
				@memos = [Memo.new(health_decay: Time.now),
									Memo.new(health_decay: Time.now - 17.days),
									Memo.new(health_decay: Time.now - 33.days)]
			end

		it "should display the average health based on all the memos" do
			helper.show_average_health.should =~ /50%/
		end

		it "should display the average health in yellow if it's below 75" do
			helper.show_average_health.should =~ /warning/
		end
	end
end
