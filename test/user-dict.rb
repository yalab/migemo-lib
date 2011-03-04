# -*- coding: utf-8 -*-
require 'test/unit'
require 'migemo'

class UserDictTest < Test::Unit::TestCase
  BASE_DIR = File.dirname(File.expand_path(__FILE__))
  def setup
    @dict = MigemoStaticDict.new(BASE_DIR + '/test-dict')
    @user_dict = MigemoUserDict.new(BASE_DIR + '/../data/user-dict.sample')
  end

  def test_mot
    migemo = Migemo.new(@dict, 'mot')
    migemo.user_dict = @user_dict
    assert_equal 'mot|ｍｏｔ|も[たちっつてと]|モ(?:[タチッツテト]|ー(?:ション|ター)|スラ)|Message\ Of\ The\ Day', migemo.regex
  end

  def test_c
    migemo = Migemo.new(@dict, 'c')
    migemo.user_dict = @user_dict
    assert_equal '[cｃちっチッ]|Sony\ CSL|ソニー(?:CSL|コンピュータサイエンス研究所)', migemo.regex
  end

  def test_nais
    migemo = Migemo.new(@dict, 'nais')
    migemo.user_dict = @user_dict
    assert_equal 'nais|ｎａｉｓ|ない[さしすせそっ]|ナイ[サシスセソッ]|奈良先端(?:大|科学技術大学院大学)', migemo.regex
  end
end









