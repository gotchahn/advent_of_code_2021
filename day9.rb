module AdventOfCode
  class Day9
    attr_accessor :raw, :basined, :board

    def initialize(raw)
      @raw = raw
      @basined = []
    end

    def basing(prebasins, x, y)
      #puts "basing #{x},#{y}"
      return if x < 0 || y < 0

      coordenate = "#{x}#{y}"
      return if basined.include?(coordenate)
      return if board[x].nil?

      value = board[x][y]
      return if value.nil?
      return if value == '9'

      # agregar al pres
      prebasins.push(value)
      basined.push(coordenate)

      #revisar adyacentes
      basing(prebasins, x+1, y) # down
      basing(prebasins, x-1, y) # up
      basing(prebasins, x, y-1) #left
      basing(prebasins, x, y+1) # right
    end

    def basins
      self.board = raw.split("\n")
      basin_count = []

      board.each_with_index do |row, rindex|
        row.chars.each_with_index do |val, vindex|
          prebasins = []

          basing(prebasins, rindex, vindex)

          if prebasins.any?
            basin_count.push(prebasins.size)
            puts "basing: #{prebasins.join(" ")}"
          end
        end
      end

      sorted = basin_count.sort
      sorted[-1] * sorted[-2] * sorted[-3]
    end
  end
end
