require_relative './ascii_renderer.rb'
require 'spec_helper.rb'

@board_setuper = GameEngine::BoardSetuper.new( "#{File.expand_path File.dirname(__FILE__)}/../assets/game_config.json", "#{File.expand_path File.dirname(__FILE__)}/../assets/ship_blueprints.json")

@board = @board_setuper.setup

@ascii_renderer = ASCIIRenderer.new(@board)

@ascii_renderer.render