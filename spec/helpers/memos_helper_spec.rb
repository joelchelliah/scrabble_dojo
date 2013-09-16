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
end
