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
        founds = []
        inputs.each do |input|
          pattern = input[0].strip
          c = input[1].strip

          match = template.scan(/#{pattern}/)

          if match.any?
            founds.push([pattern, c, match.size])
          end
        end

        founds.each do |f|
          for t in 1..f[2]
            index = template.index(/#{f[0]}/)
            template.insert(index+1, "-#{f[1]}-")
          end
        end

        @template.gsub!("-","")

        #puts "After step #{step}: #{template}"
      end
      counter = template.chars.map{|c| template.chars.count(c)}.sort
      counter
    end
  end
end
