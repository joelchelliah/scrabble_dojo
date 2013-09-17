require "spec_helper"

describe MemosController do
  describe "routing" do

    it "routes to #index" do
      get("/memos").should route_to "memos#index"
    end

    it "routes to #new" do
      get("/memos/new").should route_to "memos#new"
    end

    it "routes to #show" do
      get("/memos/1").should route_to "memos#show", :id => "1"
    end

    it "routes to #edit" do
      get("/memos/1/edit").should route_to "memos#edit", :id => "1"
    end

    it "routes to #create" do
      post("/memos").should route_to "memos#create"
    end

    it "routes to #update" do
      put("/memos/1").should route_to "memos#update", :id => "1"
    end

    it "routes to #destroy" do
      delete("/memos/1").should route_to "memos#destroy", :id => "1"
    end

    it "routes to #practice" do
      patch("/memos/1/practice").should route_to "memos#practice", id: "1"
    end

    it "routes to #results" do
      get("/memos/1/results").should route_to "memos#results", id: "1"
    end

    it "routes to #by_health" do
      get("/memos/by_health").should route_to "memos#by_health"
    end

    it "routes to #by_word_count" do
      get("/memos/by_word_count").should route_to "memos#by_word_count"
    end

    it "routes to #revise_weakest" do
      get("/memos/revise_weakest").should route_to "memos#revise_weakest"
    end
  end
end
