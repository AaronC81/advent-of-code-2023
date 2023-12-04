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

    # "Rotates" each reveal into a single hash, for example:
    #   [{ red: 12, green: 4 }, { red: 11, blue: 7, green: 2 }]
    # into:
    #   { red: [12, 11], blue: [0, 7], green: [4, 2] }
    def all_reveals_for_colours
        result = reveals.flat_map(&:keys).map { [_1, []] }.to_h

        reveals.each do |reveal|
            reveal.each do |colour, num|
                result[colour] << num
            end
        end

        result
    end

    # The most seen of each colour of cube, across all reveals
    def max_seen_of_colours = all_reveals_for_colours.to_h { |colour, nums| [colour, nums.max] }
end

def part_1(input)
    games = input.split("\n").map { Game.parse(_1) }

    possible_games = games.filter do |game|
        maxes = game.max_seen_of_colours
        maxes[:red] <= 12 && maxes[:green] <= 13 && maxes[:blue] <= 14
    end

    possible_games.map(&:id).sum
end

def part_2(input)
    games = input.split("\n").map { Game.parse(_1) }

    games
        .map { _1.max_seen_of_colours.values.inject(1, :*) }
        .sum
end


input = File.read(File.join(__dir__, '..', 'input', 'day2'))

p part_2(input)
