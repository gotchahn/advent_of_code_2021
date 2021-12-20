module AdventOfCode
  class Day16
    attr_accessor :hexa, :binary, :versions

    def initialize(hexa)
      @hexa = hexa
      @binary = hexa.to_i(16).to_s(2)
      adjust
    end

    def adjust
      first_char = hexa[0]
      if first_char == '0'
        @binary.insert(0,"0000")
      elsif first_char == '1'
        @binary.insert(0,"000")
      elsif ["2", "3"].include?(first_char)
        @binary.insert(0,"00")
      elsif ["4", "5", "6", "7"].include?(first_char)
        @binary.insert(0,"0")
      end
    end

    def decimal(bmin, bmax)
      binary[bmin..bmax].to_i(2)
    end

    def parse_literal_package(start)
      bitmin = start
      bitmax = start+4
      literal = ""
      total_bits = 0

      loop do
        total_bits += 5
        sub5 = binary[bitmin..bitmax]
        literal.concat(sub5[1..4])
        break if sub5[0] == '0'

        bitmin += 5
        bitmax += 5
      end

      puts "Literal value: #{literal.to_i(2)}"
      [total_bits, literal.to_i(2)]
    end

    def parse_operator_package(start, type)
      length_type = binary[start]
      puts "Operational package with length ID: #{length_type}"
      total_bits = 1
      offset = length_type == "0" ? 15 : 11

      bitmin = start + 1
      bitmax = start + offset
      length = decimal(bitmin, bitmax)
      puts "length: #{length}"
      total_bits += offset
      result_collection = []
      read = 0

      while read < length
        puts "#{read} < #{length} : started: #{bitmax+1}"
        bits, result = parse_package(bitmax+1)
        bitmax += bits
        read += (length_type == "0" ? bits : 1)
        total_bits += bits
        result_collection.push(result)
      end

      print "Going to result parsing with: #{result_collection} and type #{type}"
      final_result = parse_result(result_collection, type)
      puts "= #{final_result}"
      [total_bits, final_result]
    end

    def parse_result(collect, type)
      if type == 0
        # sum
        collect.sum
      elsif type == 1
        # product
        collect.inject(:*)
      elsif type == 2
        # min
        collect.min
      elsif type == 3
        # max
        collect.max
      else
        r1 = collect[0]
        r2 = collect[1]

        if type == 5
          # greater than
          if r1 > r2
            1
          else
            0
          end
        elsif type == 6
          # less than
          if r1 < r2
            1
          else
            0
          end
        else
          # equal than
          if r1 == r2
            1
          else
            0
          end
        end
      end
    end

    def parse_package(start)
      bitmin = start
      bitmax = start + 2
      total_bits = 0

      # version
      p_version = decimal(bitmin, bitmax)
      puts "Version for this package: #{p_version}"
      @versions += p_version
      total_bits += 3

      # type
      bitmin += 3
      bitmax += 3
      p_type = decimal(bitmin, bitmax)
      puts "Type for this package: #{p_type}"
      total_bits += 3

      if p_type == 4
        response = parse_literal_package(bitmax+1)
      else
        response = parse_operator_package(bitmax+1, p_type)
      end

      total_bits += response[0]
      result = response[1]

      [total_bits, result]
    end

    def parse
      @versions = 0
      bits_read, result = parse_package(0)
      result
    end
  end
end
