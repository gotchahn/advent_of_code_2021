module AdventOfCode
  class Cave
    attr_accessor :name, :aristas

    def initialize(name)
      @name = name
      @aristas = []
    end

    def small?
      /[[:upper:]]/.match(name).nil?
    end

    def add(cave)
      # no agregar repetidas
      return if aristas.map{|c| c.name}.include?(cave.name)
      aristas.push(cave)

      # cuevas grandes tienen retorno
      cave.add(self)
    end
  end

  class Day12
    attr_accessor :start, :path_count, :raw, :nodes

    def initialize(raw)
      @raw = raw
      @path_count = 0
      @nodes = []
      @start = Cave.new('start')
      build_connections
    end

    def build_connections
      input = raw.split("\n")

      input.each do |connection|
        node_pair = connection.split('-')
        n1 = find_or_create(node_pair[0])
        n2 = find_or_create(node_pair[1])

        n1.add(n2)
      end

      @start = find_or_create('start')
    end

    def find_or_create(name)
      obj = nodes.find{|node| node.name == name}

      unless obj.present?
        # create
        obj = Cave.new(name)
        nodes.push(obj)
      end

      obj
    end

    def paths
      @path_count = 0
      @start.aristas.each do |cave|
        @path_count += journey(cave, [@start], false)
      end
    end

    def journey(cave, passed, small_quota_completed)
      puts "Visiting #{passed.map{|c| c.name}.join("-")}-#{cave.name}"
      if cave.name == 'end'
        return 1
      elsif cave.name == 'start'
        # can't return to start
        return 0
      elsif cave.aristas.empty?
        # end of the road and not end
        return 0
      else
        if cave.small?
          visited_caves = passed.select{|node| node.name == cave.name}
          visited_count = visited_caves.length

          if visited_count == 1 && !small_quota_completed
            puts "Already visited #{cave.name} but quote not completed"
            # lo dejo pasas
            small_quota_completed = true
          elsif visited_count > 1 || (visited_count == 1 && small_quota_completed)
            # no more
            return 0
          end
        end

        count = 0
        cave.aristas.each do |c|
          count += journey(c, passed.clone.push(cave), small_quota_completed)
        end

        count
      end
    end
  end
end
