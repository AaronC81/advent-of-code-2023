require_relative '../utils/aoc'

Schematic = Struct.new('Schematic', :items) do
    def self.parse(lines)
        items = []

        lines.each.with_index do |line, y|
            x = 0
            while x < line.length
                if /^(\d+)/ === line[x..]
                    # Number
                    content = $1
                elsif '.' === line[x]
                    # Blank - ignore
                    x += 1
                    next
                else
                    # Symbol
                    content = line[x]
                end

                items << SchematicItem.new(x, y, content)
                x += content.length
            end
        end

        new(items)
    end

    # Find all items which are part numbers - defined by the puzzle as numbers which are adjacent
    # to a symbol
    def part_numbers
        symbols, numbers = items.partition(&:symbol?)
        numbers.filter { |num| symbols.any? { |sym| num.adjacent_to?(sym) } }
    end

    # Find all items which are gears - defined by the puzzle as `*` symbols which are adjacent to
    # two numbers - returning a map of the gear symbols to the two numbers which they are adjacent
    # to.
    def gears
        symbols, numbers = items.partition(&:symbol?)

        result = {}
        numbers.each do |num|
            symbols.each do |sym|
                next unless sym.content == '*'
                if num.adjacent_to?(sym)
                    result[sym] ||= []
                    result[sym] << num
                end
            end
        end

        result.filter { |_, nums| nums.length == 2 }
    end
end

SchematicItem = Struct.new('SchematicItem', :x, :y, :content) do
    def width = content.length
    def symbol? = !(/^\d+$/ === content)

    def adjacent_to?(other)
        # This makes the implementation easier, as we can assume that the `width` of `other` is 1
        unless !symbol? && other.symbol?
            raise "adjacent_to? must be called on a non-symbol, with a symbol parameter"
        end

        ((x - 1)..(x + width)).include?(other.x) && ((y - 1)..(y + 1)).include?(other.y)
    end
end

def part_1
    Schematic.parse(AoC.input_lines)
        .part_numbers
        .map { _1.content.to_i }
        .sum
end

def part_2
    Schematic.parse(AoC.input_lines)
        .gears
        .map { |_, (n1, n2)| n1.content.to_i * n2.content.to_i }
        .sum
end

p part_1
p part_2
