require_relative '../utils/aoc'

MapRange = Struct.new('MapRange', :dest_start, :source_start, :length) do
    def self.parse(str)
        new(*str.split.map(&:to_i))
    end

    # If the given source value lies within the source range covered by this map, returns the
    # mapped destination value. Otherwise, returns nil.
    def try_map_value(val)
        if source_range.include?(val)
            dest_start + (val - source_start)
        else
            nil
        end
    end

    def source_range = (source_start)...(source_start + length)
end

Map = Struct.new('Map', :from_category, :to_category, :ranges) do
    def self.parse(str)
        # Format:
        #   light-to-temperature map:
        #   45 77 23
        #   81 45 19
        #   68 64 13

        heading, *ranges = str.split("\n")
        from_category, _, to_category, * = str.split(/-\s/)

        new(from_category, to_category, ranges.map { MapRange.parse(_1) })
    end

    # Tries to use all of the ranges to map a source value. If none of their source ranges contain
    # the value, returns the source value unchanged instead.
    def map_value(val)
        ranges
            .map { |r| r.try_map_value(val) }
            .compact
            .first || val
    end
end

Almanac = Struct.new('Almanac', :seeds, :maps) do
    def self.parse(str)
        seeds, *maps = str.split("\n\n")
        maps = maps.map { Map.parse(_1) }
    
        # Format:
        #   seeds: 79 14 55 13
        seeds = seeds.split(':').last.split.map(&:to_i)

        new(seeds, maps)
    end

    def map_seeds = seeds.map { map_value_across_all(_1) }

    def map_value_across_all(val)
        maps.each do |m|
            val = m.map_value(val)
        end

        val
    end
end

def part_1
    almanac = Almanac.parse(AoC.input)
    almanac
        .seeds
        .map { almanac.map_value_across_all(_1) }
        .min
end

def part_2
    # TODO: This doesn't work, far too slow on actual input!
    
    almanac = Almanac.parse(AoC.input)
    seed_ranges = almanac.seeds.each_slice(2)
    seeds = seed_ranges.flat_map { |start, len| (start...(start+len)).to_a }

    seeds
        .map { almanac.map_value_across_all(_1) }
        .min
end

p part_1
p part_2
