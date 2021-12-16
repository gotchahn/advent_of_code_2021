module AdventOfCode
  class Day14
    attr_accessor :template, :inputs

    def initialize(template, raw)
      @template = template
      @inputs = raw.split("\n").map{|c|c.split("->")}
    end



    def parolymerization(steps)
      for step in 1..steps

        # scan the template
        inputs.each do |input|
          pattern = input[0].strip
          c = input[1].strip

          #loop do
          #  index = template.index(/#{pattern}/)
          #  break if index.nil?

          #  template.insert(index+1, "-#{c}-")
          #end
          @template.gsub!(/#{pattern}/, pattern.clone.insert(1,"-#{c}-"))
        end

        @template.gsub!("-","")

        #puts "After step #{step}: #{template}"
        puts "step #{step} done"
      end
      counter = template.chars.map{|c| template.chars.count(c)}.sort
      [counter.last, counter.first, counter.last-counter.first]
    end
  end
end
