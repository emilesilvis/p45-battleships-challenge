require 'spec_helper.rb'

describe Api::Client do

  subject(:api_client) { Api::Client.new('http://battle.platform45.com') }

  describe "#register" do
    before do
      VCR.use_cassette('register') do
        @response = api_client.register('Test Player', 'test@player.com')
      end
    end

    it "returns game id" do
      expect(@response[:id]).to_not be_nil
    end
    it "returns x coordinate of first salvo" do
      expect(@response[:x]).to_not be_nil
    end
    it "return y coordinate of first salvo" do
      expect(@response[:y]).to_not be_nil
    end
  end

  describe "#nuke" do
    before do
      VCR.use_cassette('register') do
        @registration_response = api_client.register('Test Player', 'test@player.com')
      end
      VCR.use_cassette('nuke') do
        @response = api_client.nuke(@registration_response[:id], 1, 1)
      end
    end

    it "returns status" do
      expect(@response[:status]).to_not be_nil
    end
    it "returns x coordinate of next salvo" do
      expect(@response[:x]).to_not be_nil
    end
    it "return y coordinate of next salvo" do
      expect(@response[:y]).to_not be_nil
    end
  end

end