Game = Struct.new('Game', :id, :reveals) do
    def self.parse(input)
        # Format:
        #   Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        raise unless /^Game (?<id>\d+): (?<reveals>.+)$/ =~ input

        reveals = reveals.split(';').map do |reveal|
            cube_infos = reveal.split(', ')
            cube_info = cube_infos
                .map do |i|
                    num, colour = i.split
                    [colour.to_sym, num.to_i]
                end
                .to_h
        end

        Game.new(id.to_i, reveals)
    end

    def max_seen_of_colours
        result = {}

        reveals.each do |reveal|
            reveal.each do |colour, num|
                if result[colour] == nil || result[colour] < num
                    result[colour] = num
                end
            end
        end

        result
    end
end

def part_1(input)
    games = input.split("\n").map { Game.parse(_1) }

    possible_games = games.filter do |game|
        maxes = game.max_seen_of_colours
        maxes[:red] <= 12 && maxes[:green] <= 13 && maxes[:blue] <= 14
    end

    possible_games.map(&:id).sum
end

input = File.read(File.join(__dir__, '..', 'input', 'day2'))

p part_1(input)
