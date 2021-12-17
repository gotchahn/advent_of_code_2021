module AdventOfCode
  class Node
    attr_accessor :value, :x, :y, :right, :down

    def initialize(value, x, y)
      @value = value
      @x = x
      @y = y
    end
  end

  class Day15
    attr_accessor :raw, :board, :start, :nodes, :traveled

    def initialize(raw)
      @raw = raw
      @board = raw.split("\n").map{|n| n.chars.map(&:to_i)}
      @start = Node.new(board[0][0], 0, 0)
      @nodes = {}
      @traveled = {}
    end

    def find_or_create(x,y)
      key = "#{x}#{y}"

      unless nodes[key]
        nodes[key] = Node.new(board[y][x], x, y)
      end

      nodes[key]
    end

    def build_graph
      board.each_with_index do |row, rindex|
        row.each_with_index do |col, cindex|
          if rindex == 0 && cindex == 0
            right_node = find_or_create(1,0)
            down_node = find_or_create(0,1)

            @start.right = right_node
            @start.down = down_node
          else
            node = find_or_create(cindex, rindex)

            if rindex < y_size - 1
              # we can get down
              node.down = find_or_create(cindex, rindex+1)
            end

            if cindex < x_size - 1
              # we can go right
              node.right = find_or_create(cindex+1, rindex)
            end
          end
        end
      end

    end

    def cheaper2
      build_graph

      right_cost = travel(@start.right)
      down_cost = travel(@start.down)

      if right_cost < down_cost
        right_cost
      else
        down_cost
      end
    end

    def travel(node)
      #puts "Traveling to [#{node.y}][#{node.x}]"
      if node.right.nil? && node.down.nil?
        return node.value
      elsif node.right.nil? && node.down.present?
        return node.value + travel(node.down)
      elsif node.right.present? && node.down.nil?
        return node.value + travel(node.right)
      else
        traveled_key = "#{node.x}#{node.y}"
        cheap_cost = traveled[traveled_key]

        if cheap_cost
          puts "Using traveled key #{traveled_key}"
          return node.value + cheap_cost
        else
          right_cost = travel(node.right)
          down_cost = travel(node.down)

          if right_cost < down_cost
            traveled[traveled_key] = right_cost
            return node.value + right_cost
          else
            traveled[traveled_key] = down_cost
            return node.value + down_cost
          end
        end
      end
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
          right_sub = board[y][right..(right+2)]
          down_sub = board[y+1][x..(x+2)]

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
