module AdventOfCode
  class Day15
    attr_accessor :raw, :board

    def initialize(raw)
      @raw = raw
      @board = raw.split("\n").map{|n| n.chars.map(&:to_i)}
    end

    def x_size
      @x_size ||= board.first.size
    end

    def y_size
      @y_size ||= board.size
    end

    def cheaper
      path = 0
      x = 0
      y = 0
      limitx = x_size - 1
      limity = y_size - 1

      loop do
        if x == limitx && y < limity
          # ya llegue al tope de x, solo bajo
          y += 1
        elsif x < limitx && y == limity
          # ya llegue al tope de y, solo me voy right
          x += 1
        else
          right = x + 1
          right_sub = board[y][right..limitx]
          down_sub = board[y+1][x..limitx]

          puts "right: #{right_sub.join(" ")} = #{right_sub.sum}"
          puts "down: #{down_sub.join(" ")} = #{down_sub.sum}"
          if right_sub.sum/right_sub.size < down_sub.sum/down_sub.size
            x += 1
          else
            y += 1
          end
        end

        puts "Add board[#{y}][#{x}] = #{board[y][x]}"
        path += board[y][x]

        break if x == limitx && y == limity
      end
      path
    end
  end
end
