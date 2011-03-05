# -*- coding: utf-8 -*-
require 'test/unit'
require 'migemo'

class RegexDictTest < Test::Unit::TestCase
  BASE_DIR = File.dirname(File.expand_path(__FILE__))
  def setup
    @dict = MigemoStaticDict.new(BASE_DIR + '/test-dict')
    @regex_dict = MigemoRegexDict.new(BASE_DIR + '/../data/regex-dict.sample')
  end

  def test_m
    migemo = Migemo.new(@dict, 'm')
    migemo.regex_dict = @regex_dict
    assert_equal '[mｍっまみむめもッマミムメモ]|\([-0-9a-zA-Z_.]+@[-0-9a-zA-Z_.]+\)', migemo.regex
  end


  def test_ur
    migemo = Migemo.new(@dict, 'ur')
    migemo.regex_dict = @regex_dict
    assert_equal 'ur|ｕｒ|う[っらりるれろ]|ウ[ッラリルレロ]|\(\(http\|https\|ftp\|afs\|wais\|telnet\|ldap\|gopher\|news\|nntp\|rsync\|mailto\)://[-_.!~*\'()a-zA-Z0-9;/?:@&=+$,%#]+\)', migemo.regex
  end

  def test_m_with_userdict
    migemo = Migemo.new(@dict, 'm')
    migemo.regex_dict = @regex_dict
    migemo.user_dict = MigemoUserDict.new(BASE_DIR + '/../data/user-dict.sample')
    assert_equal '[mｍっまみむめもッマミムメモ]|Message Of The Day|\([-0-9a-zA-Z_.]+@[-0-9a-zA-Z_.]+\)', migemo.regex
  end
end
