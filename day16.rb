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
      total_bits
    end

    def parse_length_package(start)
      bitmin = start
      bitmax = start + 14
      length = decimal(bitmin, bitmax)
      total_bits = 15
      read = 0

      while read < length
        bits = parse_package(bitmax+1)
        bitmax += bits
        read += bits
        total_bits += bits
      end

      total_bits
    end

    def parse_number_package(start)
      bitmin = start
      bitmax = start + 10
      length = decimal(bitmin, bitmax)
      total_bits = 11
      read = 0

      while read < length
        bits = parse_package(bitmax+1)
        bitmax += bits
        read += 1
        total_bits += bits
      end

      total_bits
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
        total_bits += parse_literal_package(bitmax+1)
      else
        bitmax += 1
        length = binary[bitmax]
        total_bits += 1

        if length == '0'
          puts "Length of bits Package"
          total_bits += parse_length_package(bitmax+1)
        else
          puts "Number of Package"
          total_bits += parse_number_package(bitmax+1)
        end
      end
      total_bits
    end

    def parse
      @versions = 0
      bits_read = parse_package(0)
    end
  end
end
