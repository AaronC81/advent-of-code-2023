module AoC
    def self.input
        raise "must be called from a file named 'dayX'" unless caller.find { /(day\d+)/ === _1 }
        path = File.join(__dir__, '..', 'input', $1)
        File.read(path)
    end

    def self.input_lines(&block)
        lines = input.split("\n")
        lines = lines.map(&block) if block
        lines
    end
end
