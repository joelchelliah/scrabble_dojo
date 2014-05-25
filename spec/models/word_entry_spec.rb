require 'spec_helper'

describe WordEntry do

	before { @word_entry = WordEntry.new(word: "APEKATT", letters: "AAEKPTT", length: 7, first_letter: "A") }
  subject { @word_entry }

  it { should respond_to :word }
  it { should respond_to :letters }
  it { should respond_to :length }
  it { should respond_to :first_letter }

  it { should be_valid }

  describe "when word is not present" do
  	before { @word_entry.word = nil }

  	it { should_not be_valid }
  end

  describe "when word is longer than 15 letters" do
  	before { @word_entry.word = "PEPPERKAKEFABRIKK" }

  	it { should_not be_valid }
  end

  describe "when word is already taken" do
  	before do
  		copy = @word_entry.dup
  		copy.word.downcase!
  		copy.save
  	end
  	it { should_not be_valid }
  end

  describe "when letters are not present" do
  	before { @word_entry.letters = nil }

  	it { should_not be_valid }
  end

  describe "when length is not present" do
  	before { @word_entry.length = nil }

  	it { should_not be_valid }
  end

  describe "when first letter is not present" do
  	before { @word_entry.first_letter = nil }

  	it { should_not be_valid }
  end

  describe "when retrieving word entries" do
    let!(:w1) { FactoryGirl.create(:word_entry, word: "HVERDAG", length: 7, first_letter: "H") }
    let!(:w2) { FactoryGirl.create(:word_entry, word: "YT", length: 2) }
    let!(:w3) { FactoryGirl.create(:word_entry, word: "AND", length: 3) }
    let!(:w4) { FactoryGirl.create(:word_entry, word: "WC", length: 2) }
    let!(:w5) { FactoryGirl.create(:word_entry, word: "WOK", length: 3) }
    let!(:w6) { FactoryGirl.create(:word_entry, word: "ECRU", length: 4) }
    let!(:w7) { FactoryGirl.create(:word_entry, word: "TELEFONER", length: 9, first_letter: "T") }

    #it "should be ordered alphabetically" do
    #  expect(WordEntry.all).to eq [w3, w6, w1, w7, w4, w5, w2]
    #end

    it "Should retrieve all two letter words" do
      expect(WordEntry.word_length(2)).to eq [w4, w2]
    end

    it "Should retrieve all three letter words" do
      expect(WordEntry.word_length(3)).to eq [w3, w5]
    end

    it "Should retrieve all two to five letter words" do
      expect(WordEntry.short_words).to eq [w3, w6, w4, w5, w2]
    end

    it "Should retrieve all seven to nine letter words" do
      expect(WordEntry.bingos).to eq [w1, w7]
    end

    it "Should retrieve all seven to nine letter words starting with H" do
      expect(WordEntry.bingos_from_letter("H")).to eq [w1]
    end

    it "Should retrieve all seven to nine letter words starting with T" do
      expect(WordEntry.bingos_from_letter("T")).to eq [w7]
    end
  end

  describe "when retrieving letters for bingo challenge" do
    let!(:w1) { FactoryGirl.create(:word_entry, length: 7, letters: "ABC", probability: 0.00015) }
    let!(:w2) { FactoryGirl.create(:word_entry, length: 7, letters: "ABC", probability: 0.00015) }
    let!(:w3) { FactoryGirl.create(:word_entry, length: 7, letters: "DEF", probability: 0.00014) }
    let!(:w4) { FactoryGirl.create(:word_entry, length: 7, letters: "GHI", probability: 0.000095) }
    let!(:w5) { FactoryGirl.create(:word_entry, length: 6, letters: "JKL", probability: 0.00039) }
    let!(:w6) { FactoryGirl.create(:word_entry, length: 8, letters: "MNO", probability: 0.000112) }

    context "(random)" do
      it "Should retrieve 2 unique sets of 7 letter words" do
        expect(WordEntry.tiles_for_random_bingo_challenge(2).count).to eq 2
        expect(WordEntry.tiles_for_random_bingo_challenge(2).all? {|ls| %w(ABC DEF GHI).include? ls}).to be_true
      end

      it "Should retrieve 3 unique sets of 7 letter words" do
        expect(WordEntry.tiles_for_random_bingo_challenge(3).count).to eq 3
        expect(WordEntry.tiles_for_random_bingo_challenge(3).all? {|ls| %w(ABC DEF GHI).include? ls}).to be_true
      end
    end

    context "(ordered)" do
      it "Should retrieve all unique sets of 7 letter words within range [0..1]" do
        expect(WordEntry.tiles_for_ordered_bingo_challenge(1, 2).count).to eq 2
        expect(WordEntry.tiles_for_ordered_bingo_challenge(1, 2)).to eq %w(ABC DEF)
      end

      it "Should retrieve all unique sets of 7 letter words within range [1..2]" do
        expect(WordEntry.tiles_for_ordered_bingo_challenge(2, 3).count).to eq 2
        expect(WordEntry.tiles_for_ordered_bingo_challenge(2, 3)).to eq %w(DEF GHI)
      end

      it "Should retrieve all unique sets of 7 letter words within range [0..2]" do
        expect(WordEntry.tiles_for_ordered_bingo_challenge(1, 3).count).to eq 3
        expect(WordEntry.tiles_for_ordered_bingo_challenge(1, 3)).to eq %w(ABC DEF GHI)
      end
    end
  end
end