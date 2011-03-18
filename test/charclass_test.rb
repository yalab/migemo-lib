# -*- coding: utf-8 -*-
require 'test_helper'

class CharclassTest < Test::Unit::TestCase
  def test_ruby_type
    migemo = Migemo.new('sym', migemo_dict)
    assert_equal "[]$%@\\\\-]|sym|ｓｙｍ", migemo.regex
  end

  def test_emacs_type
    migemo = Migemo.new('sym', migemo_dict)
    migemo.type = 'emacs'
    assert_equal "[]$%@\\-]\\|sym\\|ｓｙｍ", migemo.regex
  end
end
