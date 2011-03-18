# -*- coding: utf-8 -*-
require 'test_helper'

class MigemoTest < Test::Unit::TestCase
  def test_empty_string
    migemo = Migemo.new("", migemo_dict)
    assert_equal "", migemo.regex
  end

  def test_k
    migemo = Migemo.new("k", migemo_dict)
    assert_equal "[kｋかきくけこっカキクケコッ機帰気]", migemo.regex
  end

  def test_ki_with_no_optimize
    migemo = Migemo.new("ki", migemo_dict)
    migemo.optimization = 0
    assert_equal "ki|ｋｉ|き|キ|気|機|帰|機能|帰納|帰農|機能主義|機能的|帰納的", migemo.regex
  end

  def test_ki_with_optimize1
    migemo = Migemo.new("ki", migemo_dict)
    migemo.optimization = 1
    assert_equal "ki|ｋｉ|き|キ|機|帰|気", migemo.regex
  end

  def test_ki_with_optimize3
    migemo = Migemo.new("ki", migemo_dict)
    migemo.optimization = 3
    assert_equal "[きキ機帰気]|ki|ｋｉ", migemo.regex
  end

  def test_kin
    migemo = Migemo.new("kin", migemo_dict)
    migemo.optimization = 3
    assert_equal "kin|ｋｉｎ|き[っなにぬねのん]|キ[ッナニヌネノン]|機能|帰[納農]", migemo.regex 
  end

  def test_mot_with_optimze2
    migemo = Migemo.new("mot", migemo_dict)
    migemo.optimization = 2
    assert_equal "mot|ｍｏｔ|も(?:た|ち|っ|つ|て|と)|モ(?:ー(?:ション|ター)|スラ|タ|チ|ッ|ツ|テ|ト)", migemo.regex
  end

  def test_mot_with_optimze3
    migemo = Migemo.new("mot", migemo_dict)
    migemo.optimization = 3
    assert_equal "mot|ｍｏｔ|も[たちっつてと]|モ(?:[タチッツテト]|ー(?:ション|ター)|スラ)", migemo.regex
  end
end
