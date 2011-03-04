# -*- coding: utf-8 -*-
require 'test/unit'
require 'migemo'
class InsertionTest < Test::Unit::TestCase
  def setup
    @dict = MigemoStaticDict.new(File.dirname(File.expand_path(__FILE__)) + '/test-dict')
  end

  def test_mot
    migemo = Migemo.new(@dict, 'mot')
    migemo.insertion = "\\s *"
    assert_equal 'm\s *o\s *t|ｍ\s *ｏ\s *ｔ|も\s *[たちっつてと]|モ\s *(?:[タチッツテト]|ー\s *(?:シ\s *ョ\s *ン|タ\s *ー)|ス\s *ラ)', migemo.regex
  end

  def test_mot_as_emacs
    migemo = Migemo.new(@dict, 'mot')
    migemo.type = 'emacs'
    migemo.insertion = "\\s *"
    assert_equal 'm\s *o\s *t\|ｍ\s *ｏ\s *ｔ\|も\s *[たちっつてと]\|モ\s *\([タチッツテト]\|ー\s *\(シ\s *ョ\s *ン\|タ\s *ー\)\|ス\s *ラ\)', migemo.regex
  end
end
