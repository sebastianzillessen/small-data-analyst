require "rails_helper"

RSpec.describe QueryAssumptionResultsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/query_assumption_results").to route_to("query_assumption_results#index")
    end

    it "routes to #new" do
      expect(:get => "/query_assumption_results/new").to route_to("query_assumption_results#new")
    end

    it "routes to #show" do
      expect(:get => "/query_assumption_results/1").to route_to("query_assumption_results#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/query_assumption_results/1/edit").to route_to("query_assumption_results#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/query_assumption_results").to route_to("query_assumption_results#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/query_assumption_results/1").to route_to("query_assumption_results#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/query_assumption_results/1").to route_to("query_assumption_results#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/query_assumption_results/1").to route_to("query_assumption_results#destroy", :id => "1")
    end

  end
end
