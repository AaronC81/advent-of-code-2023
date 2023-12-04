require_relative '../utils/aoc'

Scratchcard = Struct.new('ScratchCard', :id, :winning_numbers, :our_numbers) do
    def self.parse(line)
        preamble, all_numbers = line.split(':')
        raise unless /^Card\s+(?<id>\d+)$/ =~ preamble
        winning_numbers, our_numbers = all_numbers
            .split('|')
            .map { _1.split.map(&:to_i) }

        new(id.to_i, winning_numbers, our_numbers)
    end

    def our_winning_numbers = winning_numbers & our_numbers
    def win_count = our_winning_numbers.length
    def points = win_count == 0 ? 0 : 2.pow(win_count - 1)
end

def part_1
    AoC
        .input_lines { Scratchcard.parse(_1) }
        .map(&:points)
        .sum
end

def part_2
    cards = AoC.input_lines { Scratchcard.parse(_1) }.to_h { [_1.id, _1] }
    card_quantities = cards.to_h { |_, card| [card.id, 1] }

    cards.each do |_, card|
        break unless cards[card.id + 1]
        card.win_count.times do |i|
            card_quantities[card.id + 1 + i] += card_quantities[card.id]
        end
    end

    card_quantities.values.sum
end

p part_1
p part_2
