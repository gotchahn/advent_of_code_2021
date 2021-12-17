module AdventOfCode
  # https://flylib.com/books/en/2.44.1/replacing_multiple_patterns_in_a_single_pass.html
  class String
  	 def mgsub(key_value_pairs=[].freeze)
    	 regexp_fragments = key_value_pairs.collect { |k,v| k }
       puts "#{Regexp.union(*regexp_fragments)}"
    	 gsub(Regexp.union(*regexp_fragments)) do |match|
          puts "match: #{match}: #{key_value_pairs.detect{|k,v| k =~ match}[1]}"
        	key_value_pairs.detect{|k,v| k =~ match}[1]
    	 end
  	 end
	end

  class Day14
    attr_accessor :template, :inputs, :counters, :letters

    def initialize(template, raw)
      @template = template
      @inputs = raw.split("\n").map{|c|c.split("->")}
      init_counter
    end

    def build_matches
      @build_matches ||= begin
        matches = []
        inputs.each do |input|
          pattern = input[0].strip
          c = input[1].strip
          mod = pattern.dup.insert(1,c)

          matches.push([pattern, [mod[0..1], mod[1..2]]])
        end
        matches
      end
    end

    def init_counter
      @counters = {}
      matches = build_matches

      matches.each do |m|
        @counters[m[0]] = template.scan(m[0]).size
      end
    end

    def paroly(steps)
      for step in 1..steps
        #NN -> B = means NB y BN y se pierde Ns NN
        step_counter = {}

        build_matches.each do |m|
          key = m[0]
          mod_pairs = m[1]

          # count of the pattern
          pn = counters[key].to_i
          mod_pairs.each do |pair|
            step_counter[pair] = step_counter[pair].to_i + pn
          end
        end

        @counters = step_counter
        puts "Step #{step} done"
      end
    end

    def risk
      letters={}
      counters.each do |k,v|
        letters[k[0]] = v
      end
      letters
    end

    def parolymerization(steps)
      matches = build_matches

      for step in 1..steps

        # scan the template
        matches.each do |m|
          #pattern = input[0].strip
          #c = input[1].strip

          #loop do
          #  index = template.index(/#{pattern}/)
          #  break if index.nil?

          #  template.insert(index+1, "-#{c}-")
          #end
          @template.gsub!(m[0], m[1])
        end
        #@template = template.mgsub(matches)
        @template = @template.tr("-","")

        #puts "After step #{step}: #{template}"
        puts "step #{step} done"
      end
      #counter = template.chars.map{|c| template.chars.count(c)}.sort
      #[counter.last, counter.first, counter.last-counter.first]
    end
  end
end
