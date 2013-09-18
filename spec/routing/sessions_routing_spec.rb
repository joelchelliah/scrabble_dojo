require "spec_helper"

describe SessionsController do
  describe "routing" do

    it "should not route to #index" do
      get("/sessions").should_not route_to "sessions#index"
    end

    it "routes to #new" do
      get("/sessions/new").should route_to "sessions#new"
    end

    it "should not route to #show" do
      get("/sessions/1").should_not route_to "sessions#show", :id => "1"
    end

    it "should not route to #edit" do
      get("/sessions/1/edit").should_not route_to "sessions#edit", :id => "1"
    end

    it "routes to #create" do
      post("/sessions").should route_to "sessions#create"
    end

    it "should not route to #update" do
      put("/sessions/1").should_not route_to "sessions#update", :id => "1"
    end

    it "routes to #destroy" do
      delete("/sessions/1").should route_to "sessions#destroy", :id => "1"
    end

    it "matches /login to sessions#new via get" do
      get("/login").should route_to "sessions#new"
    end

    it "matches /logout to sessions#destroy via delete" do
      delete("/logout").should route_to "sessions#destroy"
    end
	end
end