require "rails_helper"

RSpec.describe AssumptionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/assumptions").to route_to("assumptions#index")
    end

    it "routes to #new" do
      expect(:get => "/assumptions/new").to route_to("assumptions#new")
    end

    it "routes to #show" do
      expect(:get => "/assumptions/1").to route_to("assumptions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/assumptions/1/edit").to route_to("assumptions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/assumptions").to route_to("assumptions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/assumptions/1").to route_to("assumptions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/assumptions/1").to route_to("assumptions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/assumptions/1").to route_to("assumptions#destroy", :id => "1")
    end

  end
end
