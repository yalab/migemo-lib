#
# Ruby/Migemo - a library for Japanese incremental search.
#
# Copyright (C) 2001 Satoru Takabayashi <satoru@namazu.org>
#     All rights reserved.
#     This is free software with ABSOLUTELY NO WARRANTY.
#
# You can redistribute it and/or modify it under the terms of 
# the GNU General Public License version 2.

#
# Index Migemo's dictionary.
#
class Migemo
  class Index
    def initialize(lines)
      @lines = lines.is_a?(IO) ? lines.readlines : lines
      @index = []
    end

    def convert
      offset = 0
      @lines.each do |line|
        line.force_encoding("BINARY")
        unless line =~ /^;/
          @index <<  [offset].pack("N")
        end
        offset += line.length
      end
      self
    end
    def save(fname)
      File.open(fname, 'w') do |f|
        f.write(@index.join)
      end
    end
  end
end

if __FILE__ == $0
  Migemo::Index.new(File.open(ARGV[0])).convert.save(ARGV[0] + '.idx')
end
