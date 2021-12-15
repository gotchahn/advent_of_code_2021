module AdventOfCode
  module Day5
    def build_board(max)
      board = []
      for x in 0.upto(max) do
        row = []
        for y in 0.upto(max) do
          row << 0
        end
        board << row
      end
      board
    end

    def range(c1,c2)
      range = if c1 > c2
        c1.downto(c2)
      else
        c1.upto(c2)
      end
      range
    end

    def how_many_2(board, max)
      count = 0

      for x in 0.upto(max) do
        for y in 0.upto(max) do
          if board[x][y] >= 2
            count += 1
          end
        end
      end

      count
    end

    def print_board(board, max)
      for x in 0.upto(max) do
        puts board[x].join(" ")
      end
    end

    def danger(raw, max)
      raw_cos = raw.split("\n")
      board = build_board(max)

      # puts "initial board\n-------"
      # print_board(board, max)
      # puts "----------------------\n"

      raw_cos.each do |raw_co|
        coordenate = raw_co.split("->")
        first_co = coordenate.first.split(",").map(&:to_i)
        last_co = coordenate.last.split(",").map(&:to_i)

        #puts "x equal? #{first_co[0]} == #{last_co[0]}"
        #puts "y equal? #{first_co[1]} == #{last_co[1]}"

        if first_co[0] == last_co[0]
          # stay x, advance y
          range(first_co[1], last_co[1]).each_with_index do |y|
            board[first_co[0]][y] += 1
            #puts "board[#{first_co[0]}][#{y}] incremented to #{board[first_co[0]][y]}"
          end

        elsif first_co[1] == last_co[1]
          # stay y, advance x
          range(first_co[0], last_co[0]).each_with_index do |x|
            board[x][first_co[1]] += 1
            #puts "board[#{x}][#{first_co[1]}] incremented to #{board[x][first_co[1]]}"
          end
        else
          # remove this else for PART 1
          xs = range(first_co[0], last_co[0])
          ys = range(first_co[1], last_co[1])

          xs.each_with_index do |x|
            y = ys.next
            board[x][y] += 1
          end
        end
      end

      #puts "final board\n-------"
      #print_board(board, max)
      #puts "----------------------\n"

      how_many_2(board, max)
    end
  end
end
