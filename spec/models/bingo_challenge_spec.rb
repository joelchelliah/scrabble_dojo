require 'spec_helper'

describe "BingoChallenge:" do
  before { @challenge = FactoryGirl.create(:bingo_challenge) }
  subject { @challenge }

  it { should respond_to :mode }
  it { should respond_to :min_range }
  it { should respond_to :max_range }
  it { should respond_to :tiles_list }
  it { should respond_to :level }

  it { should be_valid }

  context "when mode is not present" do
    before { @challenge.mode = nil }

    it { should_not be_valid }
  end

  context "when min_range is less than 1" do
    before { @challenge.min_range = 0 }

    it { should_not be_valid }
  end

  context "when max_range is not greater than min range" do
    before { @challenge.max_range = @challenge.min_range }

    it { should_not be_valid }
  end

  context "when mode is random then" do
    before { @challenge = FactoryGirl.create(:bingo_challenge, mode: "random", min_range: 1, max_range: 50) }

    its (:random?) { should be_true }
    its (:ordered?) { should be_false }
    its(:name) { should eq "(50)" }
  end

  context "when mode is ordered" do
    before { @challenge.mode = "ordered" }

    its (:random?) { should be_false }
    its (:ordered?) { should be_true }

    context "and min range is 23 and max range is 157 then" do
      before do
        @challenge.min_range = 23
        @challenge.max_range = 157
      end

      its(:name) { should eq "23 - 157" }
      its (:size) { should eq 135 }
    end
  end

  describe "when retrieving challenges" do
    let!(:challenge_user) { FactoryGirl.create(:user, name: "challenge_user") }
    let!(:c1) { FactoryGirl.create(:bingo_challenge, user: challenge_user, mode: "random") }
    let!(:c2) { FactoryGirl.create(:bingo_challenge, user: challenge_user) }
    let!(:c3) { FactoryGirl.create(:bingo_challenge, user: challenge_user, min_range: 500, max_range: 520) }
    let!(:c4) { FactoryGirl.create(:bingo_challenge, user: challenge_user, min_range: 500, max_range: 510) }

    context "with mode random" do
      it "Should retrieve the single random challenge" do
        expect(challenge_user.bingo_challenges.random).to eq c1
      end
    end

    context "with mode ordered" do
      it "Should retrieve all ordered challenge sorted by min and max" do
        expect(challenge_user.bingo_challenges.ordered).to eq [c2, c4, c3]
      end
    end

  end
end
