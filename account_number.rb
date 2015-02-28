#!/usr/bin/env ruby

class AccountNumber < String

  class << self
    attr_accessor :debug
  end

  LENGTH = 9
  DIGIT_MATRIX_WIDTH = 3
  DIGIT_MATRIX_HEIGHT = 4

  @@digit_matrices = [
                        " _ " +
                        "| |" +
                        "|_|",

                        "   " +
                        "  |" +
                        "  |",

                        " _ " +
                        " _|" +
                        "|_ ",

                        " _ " +
                        " _|" +
                        " _|",

                        "   " +
                        "|_|" +
                        "  |",

                        " _ " +
                        "|_ " +
                        " _|",

                        " _ " +
                        "|_ " +
                        "|_|",

                        " _ " +
                        "  |" +
                        "  |",

                        " _ " +
                        "|_|" +
                        "|_|",

                        " _ " +
                        "|_|" +
                        " _|"
                      ]

  def self.parse_digit str
    raise(ArgumentError, "#{str} must be length #{AccountNumber::LENGTH}") unless str.length == AccountNumber::LENGTH
    parsed = @@digit_matrices.find_index(str)
    if !parsed && AccountNumber.debug      
      puts "failed parsing: "      
      str.chars.each_slice(AccountNumber::DIGIT_MATRIX_WIDTH) { |x| puts "'#{x.join}'" }
    end
    return parsed || "?"
  end

  def self.readlines filename
    account_numbers = []
    File.readlines(filename).map { |x| x.chomp.chars }.each_slice(AccountNumber::DIGIT_MATRIX_HEIGHT) do |four_lines|

      flattened = four_lines.flatten(1)
      if flattened.count != AccountNumber::LENGTH * AccountNumber::DIGIT_MATRIX_WIDTH * AccountNumber::DIGIT_MATRIX_HEIGHT
        raise(ArgumentError, "wrong record #{account_numbers.count + 1}, size: #{flattened.count}")
      end

      (top, middle, bottom)  = flattened.each_slice(AccountNumber::DIGIT_MATRIX_WIDTH).each_slice(AccountNumber::LENGTH).to_a
      stick_digits = top.zip(middle, bottom).flatten.each_slice(AccountNumber::LENGTH).map { |x| x.flatten.join }
      digit_array = stick_digits.map { |e| AccountNumber.parse_digit e  }
      account_numbers << AccountNumber::new(digit_array.join)
    end
    return account_numbers
  end

  def ill?
    return self.index("?") != nil
  end

  def valid?
    sum = 0
    self.chars.reverse.map { |x| x.to_i }.each_with_index { |d, i| sum += d * (i + 1) }
    sum % 11 == 0
  end
end

if __FILE__ == $0
  if ARGV.count < 1 
    puts "usage: #{__FILE__} file.txt"
    exit 1
  end

  AccountNumber.debug = true;
  for number in AccountNumber.readlines(ARGV[0]) do
    puts [number, number.ill? ? "ILL" : !number.valid? ? "ERR" : "" ].join(" ")
  end
end
