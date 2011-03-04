# -*- coding: utf-8 -*-
require 'test/unit'
require 'migemo'

class TestEmacsType < Test::Unit::TestCase
  def test_mot
    @dict = MigemoStaticDict.new(File.dirname(File.expand_path(__FILE__)) + '/test-dict')
    migemo = Migemo.new(@dict, 'mot')
    migemo.type = 'emacs'
    assert_equal 'mot\|ｍｏｔ\|も[たちっつてと]\|モ\([タチッツテト]\|ー\(ション\|ター\)\|スラ\)', migemo.regex
  end
end
