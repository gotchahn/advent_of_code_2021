module AdventOfCode
  module Day7
    def fuel(raw)
      input = raw.split(",").map(&:to_i)
      most_common = input.max_by{|n| input.count(n) }

      fuel = 0

      input.each do |n|
        unless n == most_common
          if n > most_common
            fuel += n - most_common
          else
            fuel += most_common - n
          end
        end
      end

      fuel
    end

    def fuel2(raw)
      input = raw.split(",").map(&:to_i)
      fuels = []

      for x in 0..(input.length - 1) do
        fuel = 0
        for y in 0..(input.length - 1) do
          unless x == y
            fuel += (input[x] - input[y]).abs
          end
        end
        fuels << fuel
      end

      fuels.min
    end

    def fuel3(raw)
      input = raw.split(",").map(&:to_i)
      size = input.size
      avg = input.sum/size
      fuels = []

      for x in 0..(size - 1) do
        fuel = 0
        change = (input[x] - avg).abs

        unless change == 0
          for f in 1..change do
            fuel += f
          end
          puts "#{input[x]} to #{avg}: #{fuel} fuel"
        end

        fuels << fuel
      end

      fuels.sum
    end
  end
end
