require 'test_helper'

class CommandLineTest < Test::Unit::TestCase
  def test_cli_migemo
    migemo = File.dirname(File.expand_path(__FILE__)) + '/../bin/migemo'
    dict   = File.dirname(File.expand_path(__FILE__)) + '/../data/migemo-dict'

    result = nil
    IO.popen("#{migemo} #{dict}", "r+") do |io|
      io.puts("hoge")
      result = io.gets.chomp
    end
    assert_equal Migemo.new("hoge").regex, result
  end
end
