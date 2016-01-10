require "rails_helper"

RSpec.describe TasksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/works/1/tasks").to route_to("tasks#index", work_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/tasks/1").to route_to("tasks#show", :id => "1")
    end

    it "routes to #start_code" do
      expect(:get => "/tasks/1/start_code").to route_to("tasks#start_code", :id => "1")
    end

    it "routes to #run_code" do
      expect(:get => "/tasks/1/run_code").to route_to("tasks#run_code", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/works/1/tasks").to route_to("tasks#create", work_id: '1')
    end

  end
end
