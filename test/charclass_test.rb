# -*- coding: utf-8 -*-
require 'test/unit'
require 'migemo'

class CharclassTest < Test::Unit::TestCase
  def setup
    @dict = MigemoStaticDict.new(File.dirname(File.expand_path(__FILE__)) + '/test-dict')
  end

  def test_ruby_type
    migemo = Migemo.new(@dict, 'sym')
    assert_equal "[]$%@\\\\-]|sym|ｓｙｍ", migemo.regex
  end

  def test_emacs_type
    migemo = Migemo.new(@dict, 'sym')
    migemo.type = 'emacs'
    assert_equal "[]$%@\\-]\\|sym\\|ｓｙｍ", migemo.regex
  end
end
