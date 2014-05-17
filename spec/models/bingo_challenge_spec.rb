require 'spec_helper'

describe "BingoChallenge:" do
  before { @challenge = BingoChallenge.new(mode: "random", order: 0, tiles_list: "QWE ASD ZXC", level: 1) }
  subject { @challenge }

  it { should respond_to :mode }
  it { should respond_to :order }
  it { should respond_to :tiles_list }
  it { should respond_to :level }

  its (:size) { should eq 50 }

  it { should be_valid }

  context "when mode is not present" do
    before { @challenge.mode = nil }

    it { should_not be_valid }
  end

  context "when order is negative" do
    before { @challenge.order = -1 }

    it { should_not be_valid }
  end

  context "when challenge doesn't contain tiles then" do
    before { @challenge = BingoChallenge.new(mode: "random", tiles_list: "", level: 1) }

    its (:reset?) { should be_true }
  end

  context "when challenge level is 0 then" do
    before { @challenge = BingoChallenge.new(mode: "random", tiles_list: "ABC", level: 0) }

    its (:reset?) { should be_true }
  end

  context "when challenge contains tiles and level is above 0 then" do
    its (:reset?) { should be_false }
  end

  describe "challenge.reset!" do
    before { @challenge.reset! }

    it "should reset and save the challenge" do
      expect(BingoChallenge.first).to_not eq nil
      expect(BingoChallenge.first.tiles_list.blank?).to eq true
      expect(BingoChallenge.first.level).to eq 0
    end
  end

  context "when mode is random then" do
    before { @challenge = BingoChallenge.new(mode: "random") }

    its (:random?) { should be_true }
    its (:ordered?) { should be_false }
    its(:name) { should eq "Random (50)" }
  end

  context "when mode is ordered" do
    before { @challenge.mode = "ordered" }

    its (:random?) { should be_false }
    its (:ordered?) { should be_true }

    context "and order is 1 then" do
      before { @challenge.order = 1 }

      its(:name) { should eq "Ordered (1 - 50)" }
    end

    context "and order is 3 then" do
      before { @challenge.order = 3 }

      its(:name) { should eq "Ordered (101 - 150)" }
    end
  end
end
