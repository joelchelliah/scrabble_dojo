require "spec_helper"

describe WordEntriesController do
  describe "routing" do

    it "should not route to #index" do
      get("/word_entries").should_not route_to "word_entries#index"
    end

		it "should not route to #show" do
      get("/word_entries/1").should_not route_to "word_entries#show", id: "1"
    end

    it "routes to #word_length" do
      get("/word_length/1").should route_to "word_entries#word_length", len: "1"
    end

    it "routes to #short_words_with letter: c" do
      get("/short_words_with/c").should route_to "word_entries#short_words_with", letter: "c"
    end

    it "routes to #short_words_with  letter: w" do
      get("/short_words_with/w").should route_to "word_entries#short_words_with", letter: "w"
    end

    it "routes to #bingos" do
      get("/bingos").should route_to "word_entries#bingos"
    end
  end
end