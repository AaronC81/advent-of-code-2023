require_relative '../utils/aoc'

def calculate_movement_distance(button_hold_time, race_time)
    speed = button_hold_time
    [(race_time - button_hold_time) * speed, 0].max
end

def product_of_number_of_winning_times(races)
    races
        .map do |time, record|
            # Count number of possible times which we can use to win
            (0..time)
                .count { calculate_movement_distance(_1, time) > record }
        end
        .inject(1, :*)
end

def part_1
    # Get data into form of [[time, record], ...]
    times, distances = AoC.input_lines
        .map { _1.split(':').last.split.map(&:to_i) }

    races = times.zip(distances).map { [_1.to_i, _2.to_i] }

    product_of_number_of_winning_times(races)
end

def part_2
    # Get data into form of [[time, record], ...]
    race = AoC.input_lines
        .map { _1.split(':').last.gsub(/\s+/, '').to_i }

    product_of_number_of_winning_times([race])
end

p part_1
p part_2
