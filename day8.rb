module AdventOfCode
  module Day8
    def build_decode
      patterns = ["cagedb", "ab", "gcdfa", "fbcad", "eafb",
        "cdfbe", "cdfgeb", "dab", "acedgfb", "cefabd"]
      dec = {}
      patterns.each_with_index do |p, index|
        key = p.chars.sort.join
        dec[key] = index
      end
      dec
    end

    def signals(raw)
      input = raw.gsub("\n"," ").split(" ")
      index = 0
      instances = 0
      decode = build_decode

      while index < input.size do
        number = ""
        for s in 0..3 do
          offset = index + s
          signal = input[offset]

          puts "Analyzing #{signal}"

          if signal.length == 2
            number.concat("1")
          elsif signal.length == 4
            number.concat("4")
          elsif signal.length == 3
            number.concat("7")
          elsif signal.length == 7
            number.concat("8")
          else
            sorted_signal = input[offset].chars.sort.join
            puts "sorted signal: #{sorted_signal}"
            number.concat(decode[sorted_signal])
          end

          puts "gave #{number}"
        end
        puts number

        instances += number.to_i
        index += 15
      end

      instances
    end

    def build_pattern(signals)
      pat = ['','','','','','']

      #get 1
      uno = signals.select{|s| s.length == 2}.first
      pat[0] = uno.chars.first
      pat[1] = uno.chars.last

      # get 7
      siete = signals.select{|s| s.length == 3}.first
      siete.chars.each do |c|
        unless pat.include?(c)
          pat[2] = c
        end
      end

      # get 4 and 5
      cuatro = signals.select{|s| s.length == 4}.first
      cincos = signals.select{|s| s.length == 5}
      cuatro.chars.each do |c|
        unless pat.include?(c)
          if cincos.all?{|p| p.include?(c)}
            # must be 3
            pat[3] = c
          else
            pat[4] = c
          end
        end
      end

      cincos.each do |five|
        inter = five.chars - pat
        puts "#{five} - #{pat.join("")} = #{inter.join("")}"
        if inter.length == 1
          # found 5!
          pat[5] = inter.first
          break
        end
      end

      # get 8
      ocho = signals.select{|s| s.length == 7}.first
      last = ocho.chars - pat
      pat[6] = last.first

      # re-think 1
      seises = signals.select{|s| s.length == 6}
      seises.each do |seis|
        uno = [pat[0], pat[1]]
        inter = uno - seis.chars
        if inter.length == 1
          if inter.first != pat[0]
            puts "re-shufle 1"
            pat[1] = pat[0]
            pat[0] = inter.first
          end
        end
      end

      pat
    end

    def signal2(raw)
      input = raw.gsub("\n"," ").split(" ")
      index = 0
      instances = 0

      while index < input.size do
        unique_signals = []
        for offset in 0..9 do
          unique_signals << input[index+offset]
        end
        index += 11

        pattern = build_pattern(unique_signals)

        puts "pattern build: #{pattern.join(" ")}"

        number = ""
        for offset in 0..3 do
          signal = input[index + offset]

          puts "Analyzing #{signal}"

          if signal.length == 2
            number.concat("1")
          elsif signal.length == 4
            number.concat("4")
          elsif signal.length == 3
            number.concat("7")
          elsif signal.length == 7
            number.concat("8")
          else
            # get the sum
            sum = 0
            signal.chars.each do |c|
              sum += pattern.index(c)
            end

            if sum == 18
              number.concat("0")
            elsif sum == 16
              number.concat("2")
            elsif sum == 11
              number.concat("3")
            elsif sum == 21
              number.concat("6")
            elsif sum == 15 && signal.length == 5
              number.concat("5")
            else
              number.concat("9")
            end
          end
          puts "gave #{number}"
        end

        instances += number.to_i
        index += 4
      end

      instances
    end
  end
end
