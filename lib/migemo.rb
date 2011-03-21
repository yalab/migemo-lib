# -*- coding: utf-8 -*-
#
# Ruby/Migemo - a library for Japanese incremental search.
#
# Copyright (C) 2001 Satoru Takabayashi <satoru@namazu.org>
#     All rights reserved.
#     This is free software with ABSOLUTELY NO WARRANTY.
#
# You can redistribute it and/or modify it under the terms of 
# the GNU General Public License version 2.

$LOAD_PATH << File.dirname(File.expand_path(__FILE__))
require 'migemo/core_ext/string'
require 'migemo-dict'
require 'migemo-regex'
require 'migemo/version'
require 'romkan'

class Migemo
  def initialize (pattern, dict=nil)
    @static_dict = if dict.nil?
                     MigemoStaticDict.new(File.dirname(File.expand_path(__FILE__)) + '/../data/migemo-dict')
                   elsif dict.is_a?(String)
                     MigemoStaticDict.new(dict)
                   else
                     dict
                   end
    @type = "ruby"
    @pattern = pattern
    @insertion = ""
    @optimization = 3

    @dict_cache = nil
    @user_dict = nil
    @regex_dict = nil
    @with_paren = false
  end
  attr_accessor :optimization
  attr_accessor :type
  attr_accessor :insertion
  attr_accessor :dict_cache
  attr_accessor :user_dict
  attr_accessor :regex_dict
  attr_accessor :with_paren

  def lookup
    if @pattern == ""
      return Regex::Alternation.new
    end
    result = if @dict_cache
               lookup_cache || lookup0
             else
               lookup0
             end
    if @user_dict
      lookup_user_dict.each{|x| result.push(x) }
    end
    result
  end

  def regex_tree
    lookup
  end

  def regex
    regex = lookup
    renderer = Regex::RendererFactory.new(regex, @type, @insertion)
    renderer.with_paren = @with_paren
    string = renderer.render
    string = renderer.join_regexes(string, lookup_regex_dict) if @regex_dict
    string
  end

  private
  # `do'   => (ど)
  # `d'    => (っ だ ぢ づ で ど)
  # `sh'   => (しゃ し しゅ しぇ しょ)
  # `don'  => (どん どな どに どぬ どね どの どっ)  # special case 1
  # `nodd' => (のっ)                                # special case 2
  # `doc'  => (どっ どち)                           # special case 3
  # `dox'  => (どっ どゃ どゅ どょ)                 # special case 4
  # `essy' => (えっしゃ えっしゅ えっしょ)          # special case 5
  # `ny'   => (にゃ にゅ にょ)                      # special case 6
  def expand_kanas
    kana = @pattern.downcase.to_kana
    /^(.*)(.)$/ =~ kana ;
    head = $1;
    last = $2;

    cand = Array.new;
    return [] if last == nil
    if last.consonant?
      if /^(.*)(.)$/ =~ head && $2.consonant?
        head2 = $1;
        beforelast = $2;
        if last == beforelast # special case 2
          cand.push head2 + "っ"
        elsif /^(.*)(.)$/ =~ head2 && beforelast == $2 && last.consonant?
          # special case 5
          cand += (beforelast + last).expand_consonant.map do |x|
            $1 + "っ" + x.to_kana
          end
        else
          cand += (beforelast + last).expand_consonant.map do |x|
            head2 + x.to_kana
          end
        end
      elsif /^(.*?)(n?)ny$/ =~ @pattern && $2 == "" # special case 6
        head2 = $1
        cand += "ny".expand_consonant.map do |x|
          head2 + x.to_kana
        end
      else
        deriv = last.expand_consonant
        deriv.push "xtsu";
        if last == "c" # special case 3
          deriv.push "chi";
        elsif last == "x" # special case 4
          deriv.push "xya", "xyu", "xyo", "xwa"
        end
        cand += deriv.map do |x| head + x.to_kana end
      end
    elsif last == "ん" # speacial case 1
      cand.push kana;
      cand += ("n".expand_consonant + ["っ"]).map do |x|
        head + x.to_kana
      end
    else
      cand.push kana
    end
    return cand.sort
  end

  # `めし' => (飯 飯合 雌蘂 雌蕊 飯櫃 目下 飯粒 召使 飯屋)
  def expand_words (dict, pattern)
    raise if pattern == nil
    words = Array.new
    dict.lookup(pattern) do |item|
      words += item.values
    end
    return words
  end

  def lookup_cache
    @dict_cache.lookup(@pattern)
  end

  def lookup0
    compiler = Regex::Compiler.new
    compiler.push(@pattern)
    compiler.push(@pattern.to_fullwidth)
    expand_kanas.each do |x| 
      compiler.push(x)
      compiler.push(x.to_katakana)
      expand_words(@static_dict, x).each do |_x| compiler.push(_x) end
    end
    expand_words(@static_dict, @pattern).each do |x| compiler.push(x) end
    compiler.uniq
    compiler.optimize(@optimization) if @optimization
    compiler.regex
  end

  def lookup_user_dict
    compiler = Regex::Compiler.new
    expand_kanas.each do |x| 
      expand_words(@user_dict, x).each do |_x| compiler.push(_x) end
    end
    expand_words(@user_dict, @pattern).each do |x| compiler.push(x) end
    compiler.uniq
    compiler.optimize(@optimization) if @optimization
    compiler.regex
  end

  def lookup_regex_dict
    regexes = []
    @regex_dict.lookup(@pattern) do |item|
      regexes += item.values
    end
    regexes
  end
end
