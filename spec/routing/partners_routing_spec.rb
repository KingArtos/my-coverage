require "rails_helper"

RSpec.describe PartnersController, type: :routing do
  describe "routing" do

    it "routes to #nearst" do
      expect(get: "/partners/nearst/32.90/-34.20").to route_to(controller: "partners", action: "nearst", lat: "32.90", long: "-34.20")
    end

    it "routes to #show" do
      expect(get: "/partners/1").to route_to("partners#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/partners").to route_to("partners#create")
    end
  end
end
