module GameEngine
  class Ship

    attr_reader :type, :length
    attr_accessor :atoms

    def initialize(type, length)
      @type = type
      @length = length
      @atoms = []
    end
  end
end