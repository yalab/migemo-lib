# -*- coding: utf-8 -*-
require 'test_helper'

class SymbolsTest < Test::Unit::TestCase
  def test_ruby
    migemo = Migemo.new("|()<>[]='\`{", migemo_dict)
    assert_equal '\\|\\(\\)\\<\\>\\[\\]\\=\\\'\\`\\{|｜（）＜＞［］＝’‘｛', migemo.regex #'
    assert(Regexp.compile migemo.regex)
  end

  def test_emacs
    migemo = Migemo.new("|()<>[]='\`{", migemo_dict)
    migemo.type = 'emacs'
    assert_equal '|()<>\[\]=\'`{\|｜（）＜＞［］＝’‘｛', migemo.regex #'
  end
end
