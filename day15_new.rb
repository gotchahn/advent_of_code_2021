module AdventOfCode
  class Day15
    attr_accessor :raw, :board, :traveled

    def initialize(raw)
      @raw = raw
      @board = raw.split("\n").map{|n| n.chars.map(&:to_i)}
      @traveled = {}
    end

    def part2
      offset = x_size
      x1 = 0
      x2 = offset-1

      #right side of the board
      for step in 1..4
        board.each_with_index do |row, rindex|
          set = row[x1..x2]
          board[rindex] = row.push(set.map{|v| v==9 ? 1 : v+1}).flatten
        end
        x1 += offset
        x2 += offset
      end
      # new x side
      @x_size = board.first.size

      # down side
      offset = y_size
      y1 = 0
      y2 = offset - 1

      for step in 1..4
        rows = board[y1..y2]
        rows.each do |row|
          board.push(row.map{|v| v==9 ? 1 : v+1})
        end
        y1 += offset
        y2 += offset
      end

      @y_size = board.size
    end

    def cheaper
      row  = 0
      col = 0

      right_cost = travel(row, col+1)
      down_cost = travel(row+1, col)

      if right_cost < down_cost
        right_cost
      else
        down_cost
      end
    end

    def travel(row, col)
      traveled_key = "#{row}-#{col}"

      if traveled[traveled_key]
        return traveled[traveled_key]
      elsif row == y_size - 1 && col == x_size - 1
        return board[row][col]
      elsif row >= y_size || col >= x_size
        return nil
      else
        right_cost = travel(row,col+1)
        down_cost = travel(row+1, col)

        cheap = [right_cost, down_cost].compact.sort.first
        traveled[traveled_key] = board[row][col] + cheap

        return traveled[traveled_key]
      end
    end

    def x_size
      @x_size ||= board.first.size
    end

    def y_size
      @y_size ||= board.size
    end
  end
end
