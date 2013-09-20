require 'spec_helper'

describe Memo do
  before { @memo = Memo.new(name: "A2", hints: "", word_list: "AB\nAD\nAG\nAH\nAI\nAK\nAL\nAM\nAN\nAP\nAR\nAS\nAT\nAU\nAV") }
  subject { @memo }

  it { should respond_to :name }
  it { should respond_to :hints }
  it { should respond_to :word_list }
  it { should respond_to :health_decay }
  it { should respond_to :num_practices }

  it { should be_valid }

  describe "when name is not present" do
  	before { @memo.name = " " }
  	it { should_not be_valid }
  end

  describe "when name is already taken" do
  	before do
  		copy = @memo.dup
  		copy.name.downcase!
  		copy.save
  	end
  	it { should_not be_valid }
  end

  describe "when word list is not present" do
  	before { @memo.word_list = " " }
  	it { should_not be_valid }
  end

  describe "when word list is valid" do
  	["a", "a\r\nb\r\nc", "a\nb\nc\n", "abc adl aga", "abc adl\r\n", "æøå"].each do |valid_list|
  		before { @memo.word_list = valid_list }
  		it { should be_valid }
  	end
  end

  describe "when word list is invalid" do
  	["a,b,c,d,e,f,g", "123 456 789", "a\nb\nc\nd\n1", "a\rb"].each do |invalid_list|
  		before { @memo.word_list = invalid_list }
  		it { should_not be_valid }
  	end
  end

  describe "after saving a memo with lowercase fields" do
    before do
      @memo.name = "b4 æøå"
      @memo.word_list = "baht bøkl bægj   \r\nbåen båer båst"
      @memo.hints = "båt\r\nbæ - dj"
      @memo.save
    end

    its(:name) { should eq "B4 ÆØÅ"}
    its(:word_list) { should eq "BAHT\nBØKL\nBÆGJ\nBÅEN\nBÅER\nBÅST"}
    its(:hints) { should eq "BÅT\r\nBÆ - DJ"}
  end

  describe "after saving a memo with no health decay" do
    before do
      @memo.health_decay = nil
      @memo.save
    end

    its(:health_decay) { should < Time.now - 9.day}
    its(:health_decay) { should > Time.now - 11.day}
  end

  describe "after saving a brand new memo" do
    before { @memo.save }

    its(:num_practices) { should eq 0 }
  end
end
