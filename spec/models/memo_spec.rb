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
  	["a", "a\nb\nc\nd", "a\nb\nc\nd\n", "abc\r\nadl", "abc\r\nadl\r\n", "æøå"].each do |valid_list|
  		before { @memo.word_list = valid_list }
  		it { should be_valid }
  	end
  end

  describe "when word list is invalid" do
  	["a,b,c,d,e,f,g", "a b c d e f g", "a\nb\nc d\ne\nf", "a\rb"].each do |invalid_list|
  		before { @memo.word_list = invalid_list }
  		it { should_not be_valid }
  	end
  end
end
