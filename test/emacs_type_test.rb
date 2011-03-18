# -*- coding: utf-8 -*-
require 'test_helper'

class TestEmacsType < Test::Unit::TestCase
  def test_mot
    migemo = Migemo.new(migemo_dict, 'mot')
    migemo.type = 'emacs'
    assert_equal 'mot\|ｍｏｔ\|も[たちっつてと]\|モ\([タチッツテト]\|ー\(ション\|ター\)\|スラ\)', migemo.regex
  end
end
