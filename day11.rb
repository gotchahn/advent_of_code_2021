module AdventOfCode
  class Day11
    attr_accessor :raw, :flashed, :board

    def initialize(raw)
      @raw = raw
    end

    def print_board
      board.each do |row|
        puts row
      end
    end

    def sum_board
      sum = 0
      board.each do |row|
        sum += row.chars.map(&:to_i).sum
      end
      sum
    end

    def increment(x,y)
      return if x < 0 || x > 9
      return if y < 0 || y > 9

      octopus = board[x][y]
      coordenate = "#{x}#{y}"

      if octopus == '9'
        # flash
        board[x][y] = '0'
        self.flashed.push(coordenate)

        # up
        increment(x-1,y)
        # down
        increment(x+1,y)
        # left
        increment(x, y-1)
        # right
        increment(x, y+1)
        # diagonal up left
        increment(x-1, y-1)
        # diagonal up right
        increment(x-1, y+1)
        # diagonal down left
        increment(x+1, y-1)
        # diagonal down right
        increment(x+1, y+1)
      else
        return if octopus == '0' && flashed.include?(coordenate)
        board[x][y] = "#{board[x][y].to_i + 1}"
      end
    end

    def flashes(steps)
      self.board = raw.split("\n")
      flashes_count = 0

      for step in 1..steps do
        self.flashed = []

        board.each_with_index do |row, rindex|
          row.chars.each_with_index do |octopus, oindex|
            increment(rindex, oindex)
          end
        end

        puts "Board After Step #{step}\n-------------"
        print_board
        puts "With #{flashed.size} flashed"
        flashes_count += flashed.size
      end

      flashes_count
    end

    def sync
      self.board = raw.split("\n")
      step = 1

      while true do
        self.flashed = []

        board.each_with_index do |row, rindex|
          row.chars.each_with_index do |octopus, oindex|
            increment(rindex, oindex)
          end
        end

        puts "Board After Step #{step}\n-------------"
        print_board
        puts "With #{flashed.size} flashed"

        if sum_board == 0
          break
        else
          step += 1
        end
      end

      step
    end
  end
end
