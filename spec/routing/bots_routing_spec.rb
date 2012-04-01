require "spec_helper"

describe BotsController do
  describe "routing" do

    it "routes to #index" do
      get("/bots").should route_to("bots#index")
    end

    it "routes to #new" do
      get("/bots/new").should route_to("bots#new")
    end

    it "routes to #show" do
      get("/bots/1").should route_to("bots#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bots/1/edit").should route_to("bots#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bots").should route_to("bots#create")
    end

    it "routes to #update" do
      put("/bots/1").should route_to("bots#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bots/1").should route_to("bots#destroy", :id => "1")
    end

  end
end
