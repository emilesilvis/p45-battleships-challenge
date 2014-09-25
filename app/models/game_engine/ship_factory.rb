require 'json'
require_relative './ship.rb'

module GameEngine
  class ShipFactory

    def initialize(path_to_blueprints)
      file = File.open(path_to_blueprints)
      @blueprints = JSON.parse(file.read)
    end

    def build(type)
      ship_types = @blueprints.map { |ship| ship['type'] }
      fail "Needs to be one of #{ship_types.join(', ')}" unless ship_types.include?(type)
      length = @blueprints.find {|ship| ship['type'] == type }['length']
      Ship.new(type, length)
    end
  end
end