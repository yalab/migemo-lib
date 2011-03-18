require 'test_helper'

class RegexTest < Test::Unit::TestCase
  def test_compile
    patterns = []
    File.open(File.dirname(File.expand_path(__FILE__)) + '/../data/migemo-dict') do |f|
      lines = f.readlines.map(&:chomp)
      10.times{ patterns << lines.slice!(rand(lines.length)) }
    end
    patterns.each do |pattern|
      migemo = Migemo.new(migemo_dict, pattern)
      assert Regexp.compile(migemo.regex)
    end
  end
end

