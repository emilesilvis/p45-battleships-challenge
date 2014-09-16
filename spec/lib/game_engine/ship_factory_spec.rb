require 'spec_helper'

describe GameEngine::ShipFactory do
  let(:path_to_blueprints) { Rails.root.join("spec/assets/ship_blueprints.json") }

  let(:blueprints) { JSON.parse(File.open(path_to_blueprints).read) }

  describe "#build" do
    let(:ship_factory) { GameEngine::ShipFactory.new(path_to_blueprints) }

    context "whith invalid type" do
      it { expect{ ship_factory.build('invalid_type') }.to raise_error("Needs to be one of #{blueprints.map { |ship| ship['type'] }.join(', ')}") }
    end

    context "whith valid type" do
      it do
        blueprints.each do |blueprint|
          expect(ship_factory.build(blueprint['type'])).to be_a GameEngine::Ship
        end
      end

      it "Ship should have correct type attribute as per blueprint" do
        blueprints.each do |blueprint|
          expect(ship_factory.build(blueprint['type']).type).to eq blueprint['type']
        end
      end

      it "Ship should have correct length attribute as per blueprint" do
        blueprints.each do |blueprint|
          expect(ship_factory.build(blueprint['type']).length).to eq blueprint['length']
        end
      end
    end
  end
end
