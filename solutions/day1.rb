input = File.read(File.join(__dir__, '..', 'input', 'day1'))

def part_1(input)
    calibration_values =
        input.split("\n").map do |line|
            digits_on_line = line.chars
                .map { Integer(_1) rescue nil }
                .compact

            digits_on_line.first * 10 + digits_on_line.last
        end

    calibration_values.sum
end

def part_2(input)
    digit_words = {
        "one" => 1,
        "two" => 2,
        "three" => 3,
        "four" => 4,
        "five" => 5,
        "six" => 6,
        "seven" => 7,
        "eight" => 8,
        "nine" => 9,
    }

    calibration_values =
        input.split("\n").map do |line|
            # Find the first digit
            first_digit = line.chars.each.with_index do |c, i|
                if (Integer(c) rescue false)
                    break Integer(c)
                elsif (_, value = digit_words.find { |word, _| line[i..].start_with?(word) })
                    break value
                end
            end

            # Find the last digit
            last_digit = line.chars.each.with_index.reverse_each do |c, i|
                if (Integer(c) rescue false)
                    break Integer(c)
                elsif (_, value = digit_words.find { |word, _| line[..i].end_with?(word) })
                    break value
                end
            end

            first_digit * 10 + last_digit
        end

    calibration_values.sum
end

puts part_2(input)
