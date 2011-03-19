require File.dirname(File.expand_path(__FILE__)) + '/../lib/migemo'

class Migemo
  class Cache
    def initialize(dict, chars)
      @dict = dict
      @static_dict = MigemoStaticDict.new(dict)
      @word_file = chars
    end

    def generate
      @cache = []
      @index = []
      idx = 0
      lines = File.open(@word_file)
      lines.each do |line|
        pattern = line.chomp!
        next if pattern == "" || pattern.nil?

        migemo = Migemo.new(pattern, @static_dict)
        migemo.optimization = 3
        data = Marshal.dump(migemo.regex_tree)
        output = [pattern.length].pack("N") + pattern + [data.length].pack("N") + data
        @cache << output
        @index << [idx].pack("N")
        idx += output.length
      end
      self
    end

    def save(dst)
      File.open(dst, "w") do |f|
        f.write(@cache.join)
      end
      File.open(dst + '.idx', "w") do |f|
        f.write(@index.join)
      end
    end
  end
end


