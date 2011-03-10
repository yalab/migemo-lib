# -*- coding: utf-8 -*-
require 'test_helper'

class RegexDictTest < Test::Unit::TestCase
  def test_m
    migemo = Migemo.new(migemo_dict, 'm')
    migemo.regex_dict = regex_dict
    assert_equal '[mｍっまみむめもッマミムメモ]|\([-0-9a-zA-Z_.]+@[-0-9a-zA-Z_.]+\)', migemo.regex
  end


  def test_ur
    migemo = Migemo.new(migemo_dict, 'ur')
    migemo.regex_dict = regex_dict
    assert_equal 'ur|ｕｒ|う[っらりるれろ]|ウ[ッラリルレロ]|\(\(http\|https\|ftp\|afs\|wais\|telnet\|ldap\|gopher\|news\|nntp\|rsync\|mailto\)://[-_.!~*\'()a-zA-Z0-9;/?:@&=+$,%#]+\)', migemo.regex
  end

  def test_m_with_userdict
    migemo = Migemo.new(migemo_dict, 'm')
    migemo.regex_dict = regex_dict
    migemo.user_dict = user_dict
    assert_equal '[mｍっまみむめもッマミムメモ]|Message Of The Day|\([-0-9a-zA-Z_.]+@[-0-9a-zA-Z_.]+\)', migemo.regex
  end
end
