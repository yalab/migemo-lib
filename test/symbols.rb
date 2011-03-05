# -*- coding: utf-8 -*-
require 'test/unit'
require 'migemo'

class SymbolsTest < Test::Unit::TestCase
  def setup
    @dict = MigemoStaticDict.new(File.dirname(File.expand_path(__FILE__)) + '/test-dict')
  end

  def test_ruby
    migemo = Migemo.new(@dict, "|()<>[]='\`{")
    assert_equal '\\|\\(\\)\\<\\>\\[\\]\\=\\\'\\`\\{|｜（）＜＞［］＝’‘｛', migemo.regex #'
    assert(Regexp.compile migemo.regex)
  end

  def test_emacs
    migemo = Migemo.new(@dict, "|()<>[]='\`{")
    migemo.type = 'emacs'
    assert_equal '|()<>\[\]=\'`{\|｜（）＜＞［］＝’‘｛', migemo.regex #'
  end
end
