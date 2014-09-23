module GameEngine
  class Board

    attr_reader :width, :height, :ships, :atoms

    def initialize(width, height)
      @width = width
      @height = height
      @ships = []
      @atoms = []
    end

    def salvos
      @atoms.select { |atom| atom.manifestation == :salvo}
    end

    def hits
      @atoms.select { |atom| atom.manifestation == :hit}
    end

  end
end