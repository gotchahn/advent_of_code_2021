module AdventOfCode
  def increments(sonar)
    last = sonar[0]
    increments = 0

    sonar.each do |measure|
      if last < measure
        increments += 1
      end
      last = measure.to_i
    end

    increments
  end

  def sums_measurements(sonar)
    sums = []
    sonar.each_with_index do |t, index|
      v1 = sonar[index]
      v2 = sonar[index+1]
      v3 = sonar[index+2]
      break if [v1, v2, v3].any?{|v| v.nil?}
      sums << v1+v2+v3
    end

    sums
  end

  def travel(log)
    x = 0
    y = 0

    log.each do |command|
      values = command.split(" ")

      case values[0]
      when "forward"
        x += values[1].to_i
      when "down"
        y += values[1].to_i
      when "up"
        y -= values[1].to_i
      end
    end
    x * y
  end

  def travel2(log)
    x = 0
    y = 0
    aim = 0

    log.each do |command|
      values = command.split(" ")

      case values[0]
      when "forward"
        x += values[1].to_i
        y += aim * values[1].to_i
      when "down"
        aim += values[1].to_i
      when "up"
        aim -= values[1].to_i
      end
    end
    x * y
  end

  def to_decimal(binary)
    raise ArgumentError if binary.match?(/[^01]/)

    binary.reverse.chars.map.with_index do |digit, index|
      digit.to_i * 2**index
    end.sum
  end

  def gamma(report)
    counts = []

    for x in 0..11 do
      counts << [0,0]
    end

    report.each do |r|
      for x in 0..11 do
        if r[x] == '0'
          counts[x][0] += 1
        else
          counts[x][1] += 1
        end
      end
    end

    g = ""
    for x in 0..11 do
      if counts[x][0] > counts[x][1]
        g.concat("0")
      else
        g.concat("1")
      end
    end

    g
  end

  def power_consumption(report)
    g = gamma(report)
    e = g.tr("01", "10")
    to_decimal(g) * to_decimal(e)
  end

  def oxygen(report)
    length = report.first.length
    count0 = 0
    count1 = 0
    bit = 0

    while report.length > 1 do
      report.each do |r|
        if r[bit] == '0'
          count0 += 1
        else
          count1 += 1
        end
      end

      if count0 > count1
        report = report.select{|r| r[bit] == '0'}
      else
        report = report.select{|r| r[bit] == '1'}
      end

      bit += 1
      count0 = 0
      count1 = 0
    end

    report.first
  end

  def co2(report)
    length = report.first.length
    count0 = 0
    count1 = 0
    bit = 0

    while report.length > 1 do
      report.each do |r|
        if r[bit] == '0'
          count0 += 1
        else
          count1 += 1
        end
      end

      if count0 <= count1
        report = report.select{|r| r[bit] == '0'}
      else
        report = report.select{|r| r[bit] == '1'}
      end

      bit += 1
      count0 = 0
      count1 = 0
    end

    report.first
  end

  def life_support(report)
    ox = oxygen(report)
    co = co2(report)
    puts "multiplying #{to_decimal(ox)} with #{to_decimal(co)}"
    to_decimal(ox) * to_decimal(co)
  end

  def build_boards(input)
    splits = input.split("\n")
    boards = []
    single_board = []

    splits.each do |row|
      if row.empty?
        # board done
        boards << single_board
        single_board = []
      else
        single_board << row.split(" ").map(&:to_i)
      end
    end

    boards << single_board if single_board.any?

    boards
  end

  def board_winner(boards, numbers)
    numbers.each do |number|
      boards.each do |board|
        board.each do |row|
          row.each_with_index do |val, index|
            if val == number
              row[index] = -1

              # check if the winner
              if row.sum == -5
                return WinnerBoard.new(board, number)
              elsif [board[0][index], board[1][index], board[2][index], board[3][index], board[4][index]].sum == -5
                return WinnerBoard.new(board, number)
              end
            end
          end
        end
      end
    end
  end

  def last_board_winner(boards, numbers)
    nboards = boards.size
    bwon = []

    numbers.each do |number|
      boards.each_with_index do |board, bindex|
        board.each do |row|
          row.each_with_index do |val, index|
            if val == number
              row[index] = -1

              # check if the winner
              col_sum = [board[0][index], board[1][index], board[2][index], board[3][index], board[4][index]].sum

              if row.sum == -5 || col_sum == -5
                bwon << bindex unless bwon.include?(bindex)

                puts "The board #{bindex} winner is the #{bwon.size}"
                return WinnerBoard.new(board, number) if bwon.size == nboards
              end
            end
          end
        end
      end
    end
  end

  class WinnerBoard
    attr_accessor :board, :lucky_number

    def initialize(b, ln)
      self.board = b
      self.lucky_number = ln
    end

    def lucky
      sum = 0
      board.each do |row|
        row.each do |val|
          unless val == -1
            sum += val
          end
        end
      end
      sum * lucky_number
    end
  end

  def lowlow(raw)
    input = raw.split("\n")
    lows = []

    input.each_with_index do |row, index|
      row.chars.each_with_index do |c, cindex|
        check = true
        #print "Checking #{c}"
        # up
        if index > 0
          #print " up with #{input[index-1].chars[cindex]}"
          check &= c.to_i < input[index-1].chars[cindex].to_i
          #print " result #{check}"
        end

        # down
        if index < input.length - 1
          #print " down with #{input[index+1].chars[cindex]}"
          check &= c.to_i < input[index+1].chars[cindex].to_i
          #print " result #{check}"
        end

        # left
        if cindex > 0
          #print " left with #{input[index].chars[cindex-1]}"
          check &= c.to_i < input[index].chars[cindex-1].to_i
          #print " result #{check}"
        end

        # right
        if cindex < row.length - 1
          #print " right with #{input[index].chars[cindex+1]}"
          check &= c.to_i < input[index].chars[cindex+1].to_i
          #print " result #{check}"
        end

        #puts " and was the lowest? #{check}"

        lows << c.to_i if check
      end
    end
    lows.sum + lows.size
  end

  def grammar
    {
      ')' => '(',
      ']' => '[',
      '}' => '{',
      '>' => '<'
    }
  end

  def points
    {
      ')' => 3,
      ']' => 57,
      '}' => 1197,
      '>' => 25137
    }
  end

  def points2
    {
      '(' => 1,
      '[' => 2,
      '{' => 3,
      '<' => 4
    }
  end

  def compile(raw)
    input = raw.split("\n")
    errors = 0

    input.each do |line|
      line_compiler = []

      line.chars.each do |c|
        if ['(', '[', '{', '<'].include?(c)
          line_compiler.push(c)
        else
          opening = line_compiler.pop
          if opening != grammar[c]
            errors += points[c]
            #puts "Found closing #{c} and the last was #{opening} that should be equal as #{grammar[c]}, error #{error}"
            break
          end
        end
      end
    end
    errors
  end

  def compile2(raw)
    input = raw.split("\n")
    errors = []

    input.each do |line|
      line_points = 0
      line_compiler = []

      line.chars.each do |c|
        if ['(', '[', '{', '<'].include?(c)
          line_compiler.push(c)
        else
          opening = line_compiler.pop
          if opening != grammar[c]
            # error, ignore
            line_compiler = []
            break
          end
        end
      end

      # loop the incomplete
      if line_compiler.any?
        #puts "Pointing #{line_compiler.join("")}"
        while line_compiler.any? do
          opening = line_compiler.pop
          line_points += points2[opening]
          #puts "line compiler increase to #{line_points}"
          line_points *= 5 if line_compiler.any?
          #puts "line compiler increase to ater * 5 #{line_points}"
        end
      end

      puts "Points for this line #{line_points}"
      errors << line_points if line_points > 0
    end
    errors
  end
end
