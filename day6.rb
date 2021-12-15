module AdventOfCode
  module Day6
    def lanterfish_after(raw, days)
      lanterfishes = raw.split(",").map(&:to_i)
      count = lanterfishes.size

      for day in 1..days do

        for f in 0..(count-1) do
          if lanterfishes[f] == 0
            lanterfishes[f] = 6
            lanterfishes << 8
            count += 1
          else
            lanterfishes[f] -= 1
          end
        end
        puts "After #{day} days: #{count}"
      end

      count
    end

    def build_batch(raw)
      batch = [0,0,0,0,0,0,0,0,0]
      initial = raw.split(",").map(&:to_i)

      initial.each do |i|
        batch[i] += 1
      end

      batch
    end

    def conquer_of_lanterfishes(raw, days)
      batch = build_batch(raw)
      for day in 1..days do
        # first empty 0s
        zeros = batch[0]
        batch[0] = 0

        # move around the rest
        for i in 1..8 do
          batch[i-1] = batch[i]
        end

        # increase 6
        batch[6] += zeros
        # set new 8s
        batch[8] = zeros

        puts "After #{day} days: #{batch.sum}"
      end
    end
  end
end
