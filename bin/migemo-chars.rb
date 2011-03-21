require 'rubygems'
require 'romkan'
class Array
  def uniq_c
    self.group_by{|i| i }.map{|k, v| [k, v.length] }
  end
end

module Migemo
  class Chars
    def initialize(src_file)
      File.open("data/migemo-dict", 'r:utf-8') do |f|
        @words = f.readlines.map{|l| l.split[0] }
      end
    end

    def generate
      words = @words.map do |word, ix|
        if /^\w+$/ =~ word
          word
        else
          roma = word.to_roma;
          [roma, roma.to_kunrei]
        end
      end
      words.flatten!
      range = (1..8)
      words.map!{|w| range.map{|n| w[0, n] if w[n] }.compact }
      words.flatten!
      @frequents = words.uniq_c.sort{|a, b| b[1] <=> a[1] }.map(&:first)[0..500].sort
      self
    end

    def save(fname)
      File.open(fname, "w"){|f| f.write(@frequents.join("\n")) }
    end
  end
end
