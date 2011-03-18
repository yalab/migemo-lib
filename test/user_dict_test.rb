# -*- coding: utf-8 -*-
require 'test_helper'

class UserDictTest < Test::Unit::TestCase
  def test_mot
    migemo = Migemo.new('mot', migemo_dict)
    migemo.user_dict = user_dict
    assert_equal 'mot|ｍｏｔ|も[たちっつてと]|モ(?:[タチッツテト]|ー(?:ション|ター)|スラ)|Message Of The Day', migemo.regex
  end

  def test_c
    migemo = Migemo.new('c', migemo_dict)
    migemo.user_dict = user_dict
    assert_equal '[cｃちっチッ]|Sony CSL|ソニー(?:CSL|コンピュータサイエンス研究所)', migemo.regex
  end

  def test_nais
    migemo = Migemo.new('nais', migemo_dict)
    migemo.user_dict = user_dict
    assert_equal 'nais|ｎａｉｓ|ない[さしすせそっ]|ナイ[サシスセソッ]|奈良先端(?:大|科学技術大学院大学)', migemo.regex
  end
end
