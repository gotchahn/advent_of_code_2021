module AdventOfCode
  class Day13
    attr_accessor :raw, :board, :raw_fold, :step

    def initialize(raw, raw_fold)
      @raw = raw
      @raw_fold = raw_fold
      @step = 0
      build_board
    end

    def input
      @input ||= raw.split("\n").map{|c| c.split(",").map(&:to_i)}
    end

    def fold_input
      @fold_input ||= raw_fold.split("\n").map{|f| f.split("fold along")[1].strip}.map{|c| c.split("=")}
    end

    def x_size
      @x_size ||= input.map{|v| v[0]}.sort.last
    end

    def y_size
      @y_size ||= input.map{|v| v[1]}.sort.last
    end

    def build_board
      @board = []

      for y in 0..y_size do
        @board.push((0..x_size).to_a.map { |x| '.' })
      end

      input.each do |coordenate|
        x = coordenate[1]
        y = coordenate[0]

        board[x][y] = '#'
      end
    end

    def dots_count
      dots = 0
      board.each do |row|
        #puts "#{row.join(" ")}"
        row.each do |val|
          dots += 1 if val == '#'
        end
      end
      dots
    end

    def print
      board.each do |row|
        puts row.join("")
      end
    end

    def fold
      fold_input.each_with_index do |coordenate, index|
        axis = coordenate[0]
        rowcol = coordenate[1].to_i

        if axis == "y"
          fold_y(rowcol)
        else
          fold_x(rowcol)
        end

        #puts "Dots after #{index+1} fold #{axis}=#{rowcol}: #{dots_count}"
        puts "Folded #{axis}=#{rowcol}: #{dots_count}"
        print
      end
    end

    def step_fold
      coordenate = fold_input[step]
      return if coordenate.nil?

      axis = coordenate[0]
      rowcol = coordenate[1].to_i

      if axis == "y"
        fold_y(rowcol)
      else
        fold_x(rowcol)
      end

      #puts "Dots after #{index+1} fold #{axis}=#{rowcol}: #{dots_count}"
      puts "Folded #{axis}=#{rowcol}"
      print
      @step += 1
    end

    def fold_y(row)
      new_board = []
      remaining_rows = y_size-row
      #puts "remaining_rows #{remaining_rows}"

      # BUTTOM UP
      for y in 1..remaining_rows do
        new_row = []

        for x in 0..x_size do
          if [board[row+y][x], board[row-y][x]].include?("#")
            new_row.push("#")
          else
            new_row.push(".")
          end
        end

        new_board.unshift(new_row.clone)
      end

      # check if we must get rows from board
      total_folded = remaining_rows * 2
      missing_rows = y_size - total_folded

      if missing_rows > 0
        for m in (missing_rows-1).downto(0) do
          new_board.unshift(board[m])
        end
      end

      @board = new_board
      # update y_size
      @y_size = board.size-1
    end

    def fold_x(col)
      new_board = []
      remaining_cols = x_size-col
      total_folded = remaining_cols * 2
      missing_cols = x_size - total_folded
      total_x = remaining_cols + missing_cols
      #puts "remaining_cols #{remaining_cols}"

      # build the new empty board
      for y in 0..y_size do
        new_board.push((1..total_x).to_a.map { |x| '.' })
      end

      # set the missing_cols
      if missing_cols > 0
        for r in 0..y_size do
          for c in 0..(missing_cols-1) do
            new_board[r][c] = board[r][c]
          end
        end
      end

      # right left
      for y in 0..y_size do
        for x in 1..remaining_cols do
          if [board[y][col+x], board[y][col-x]].include?("#")
            new_board[y][col-x] = "#"
          else
            new_board[y][col-x] = "."
          end
        end
      end

      @board = new_board
      @x_size = board.first.size - 1
    end
  end
end
