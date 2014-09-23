module GameEngine
  class Atom

    attr_reader :manifestation
    attr_accessor :x, :y

    def initialize(manifestation)
      @manifestation = manifestation
    end

  end
end