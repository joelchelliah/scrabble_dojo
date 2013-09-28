require 'spec_helper'

describe Memo do

  let(:user) { FactoryGirl.create(:user) }
  before { @memo = user.memos.build(name: "A2", hints: "", word_list: "AB\nAD\nAG\nAH\nAI\nAK\nAL\nAM\nAN\nAP\nAR\nAS\nAT\nAU\nAV") }
  subject { @memo }

  it { should respond_to :name }
  it { should respond_to :hints }
  it { should respond_to :word_list }
  it { should respond_to :health_decay }
  it { should respond_to :num_practices }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:accepted_words) }
  it { should respond_to(:best_time) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "after saving a new memo" do
    before { @memo.save }

    its(:num_practices) { should eq 0 }
    its(:health_decay) { should < Time.now - 9.day}
    its(:health_decay) { should > Time.now - 11.day}
  end

  describe "when user_id is not present" do
    before { @memo.user_id = nil }
    it { should_not be_valid }
  end

  describe "when name is not present" do
  	before { @memo.name = " " }
  	it { should_not be_valid }
  end

  describe "when name is already taken" do
  	before do
  		copy = @memo.dup
  		copy.name.downcase!
  		copy.save
      @memo.name.downcase!
  	end
  	it { should_not be_valid }
  end

  describe "when word list is not present" do
  	before { @memo.word_list = " " }
  	it { should_not be_valid }
  end

  describe "when word list is invalid" do
    ["a,b,c,d,e,f,g", "123 456 789", "a\nb\nc\nd\n1", "a\rb"].each do |invalid_list|
      before { @memo.word_list = invalid_list }
      it { should_not be_valid }
    end
  end

  describe "when word list is valid" do
    ["a", "a\nb\nc", "a\nb\nc\n", "abc adl aga", "abc adl\r\n", "æøå"].each do |valid_list|
      before { @memo.word_list = valid_list }
      it { should be_valid }
    end
  end

  describe "when accepted words list is invalid" do
    ["a,b,c,d,e,f,g", "123 456 789", "a\nb\nc\nd\n1", "a\rb"].each do |invalid_list|
      before { @memo.accepted_words = invalid_list }
      it { should_not be_valid }
    end
  end

  describe "when accepted words list is valid" do
    ["a", "a\nb\nc", "a\nb\nc\n", "abc adl aga", "abc adl\r\n", "æøå"].each do |valid_list|
      before { @memo.accepted_words = valid_list }
      it { should be_valid }
    end
  end

  describe "after saving a memo with lowercase fields" do
    before do
      @memo.name = "b4 æøå"
      @memo.word_list = "baht bøkl bægj   \r\nbåen båer båst"
      @memo.hints = "båt\r\nbæ - dj"
      @memo.accepted_words = "bank berg bisk"
      @memo.save
    end

    its(:name) { should eq "B4 ÆØÅ"}
    its(:word_list) { should eq "BAHT\nBØKL\nBÆGJ\nBÅEN\nBÅER\nBÅST"}
    its(:hints) { should eq "BÅT\r\nBÆ - DJ"}
    its(:accepted_words) { should eq "BANK\nBERG\nBISK" }
  end
end
