require "spec_helper"

describe DojoController do
  describe "routing" do

    it "matches thr root path to dojo#home" do
      get("/").should route_to "dojo#home"
    end

    it "matches /home to dojo#home via get" do
      get("/home").should route_to "dojo#home"
    end
	end
end