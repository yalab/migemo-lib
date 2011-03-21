# -*- coding: utf-8 -*-
require 'test_helper'

class CommandLineTest < Test::Unit::TestCase
  def setup
    base_dir = File.dirname(File.expand_path(__FILE__)) + '/..'
    @migemo = base_dir + '/bin/migemo'
    @dict   = base_dir + '/data/migemo-dict'
    @regex_dict = base_dir + '/data/regex-dict.sample'
  end
  def test_cli_migemo
    result = nil
    IO.popen("#{@migemo} #{@dict}", "r+") do |io|
      io.puts("hoge")
      result = io.gets.chomp
    end
    assert_equal Migemo.new("hoge").regex, result
  end

  def test_cli_migemo_with_regexp_dir
    result = nil
    IO.popen("#{@migemo} #{@dict} -r #{@regex_dict}", "r+") do |io|
      io.puts("url")
      result = io.gets.chomp
    end
    assert_match /telnet/, result
  end
end
