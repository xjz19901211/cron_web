require "rails_helper"

RSpec.describe UserLogsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/user_logs").to route_to("user_logs#index")
    end

  end
end
