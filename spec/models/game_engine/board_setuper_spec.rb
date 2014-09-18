require 'spec_helper.rb'

describe GameEngine::BoardSetuper do

  let(:path_to_game_config) { Rails.root.join("spec/assets/game_config.json") }

  subject(:board_setuper) { GameEngine::BoardSetuper.new(path_to_game_config, Rails.root.join("spec/assets/ship_blueprints.json")) }

  describe "#setup" do
    before do
      @game_config = JSON.parse(File.open(path_to_game_config).read)
      @board = board_setuper.setup
    end

    it { expect(@board).to be_a GameEngine::Board }

    it "creates a Board with dimensions as per the game config" do
      expected_height, expected_width = @game_config['board']['height'], @game_config['board']['width']
      expect(@board.height).to eq expected_height
      expect(@board.width).to eq expected_width
    end

    it "randomply places a set of Ships on Board as per the game config" do
      @game_config['ships'].each do |ship_config|
        expect(@board.ships.select { |ship| ship.type == ship_config['type'] }.size).to eq ship_config['quantity']
      end
    end

  end
end