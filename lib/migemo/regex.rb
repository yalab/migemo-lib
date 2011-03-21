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

module Migemo
  class Regex
    def initialize (pattern, dict=nil)
      @static_dict = if dict.nil?
                       MigemoStaticDict.new(File.dirname(File.expand_path(__FILE__)) + '/../../data/migemo-dict')
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

    class Alternation < Array
      def sort
        self.clone.replace(super)
      end

      def uniq
        self.clone.replace(super)
      end

      def map
        self.clone.replace(super {|x| yield(x)})
      end

      def delete_if
        self.clone.replace(super {|x| yield(x)})
      end

      def select
        self.clone.replace(super {|x| yield(x)})
      end
    end

    class Concatnation < Array
      def map
        self.clone.replace(super {|x| yield(x)})
      end
    end

    class CharClass < Array
    end

    class Compiler
      def initialize
        @regex = Alternation.new
      end
      attr_reader :regex

      def push (item)
        if item and item != ""
          @regex.push(item)
        end
      end

      def uniq
        @regex.uniq
      end

      def optimize (level)
        @regex = optimize1(@regex) if level >= 1
        @regex = optimize2(@regex) if level >= 2
        @regex = optimize3(@regex) if level >= 3
      end

      private
      # ["運", "運動", "運転", "日本", "日本語"] => ["安" "運" "日本"]
      # (運|運動|運転|日本|日本語) => (安|運|日本)
      def optimize1 (regex)
        prefixpat = nil
        sorted = (defined?(Encoding)) ? regex.sort_by{|s| s.encode("EUC-JP") } : regex.sort
        sorted.select do |word|
          if prefixpat && prefixpat.match(word) then
            false # excluded
          else
            prefixpat = Regexp.new("^" + Regexp.quote(word))
            true # included
          end
        end
      end

      # (あああ|ああい|ああう)
      # => (あ(あ(あ|い|う)))
      def optimize2 (regex)
        tmpregex = (defined?(Encoding)) ? regex.sort_by{|s| s.encode("EUC-JP") }.clone : regex.sort.clone # I wish Array#cdr were available...
        optimized = Alternation.new
        until tmpregex.empty?
          head = tmpregex.shift
          initial = head.first
          friends = Alternation.new
          while item = tmpregex.first
            if initial == item.first
              friends.push(item.rest)
              tmpregex.shift
            else
              break
            end
          end
          if friends.empty?
            optimized.push head
          else
            concat = Concatnation.new
            concat.push(initial)
            friends.unshift(head.rest) 
            concat.push(optimize2(friends))
            optimized.push(concat)
          end
        end
        return optimized
      end

      # (あ|い|う|え|お)
      # => [あいうえお]
      def optimize3 (regex)
        charclass = CharClass.new
        if regex.instance_of?(Alternation)
          regex.delete_if do |x|
            if x.instance_of?(String) && x =~ /^.$/ then
              charclass.push(x)
              true
            end
          end
        end

        if charclass.length == 1
          regex.unshift charclass.first
        elsif charclass.length > 1
          regex.unshift charclass
        end

        regex.map do |x|
          if x.instance_of?(Alternation) || x.instance_of?(Concatnation)
            optimize3(x)
          else
            x
          end
        end
      end
    end

    class Metachars
      def initialize
        @bar = '|'
        @lparen = '('
        @rparen = ')'
      end
      attr_accessor :bar
      attr_accessor :lparen
      attr_accessor :rparen
    end

    class EgrepMetachars < Metachars
    end

    class PerlMetachars < Metachars
      def initialize
        @bar = '|'
        @lparen = '(?:'
        @rparen = ')'
      end
    end

    class RubyMetachars < Metachars
    end

    class EmacsMetachars < Metachars
      def initialize
        @bar = '\\|'
        @lparen = '\\('
        @rparen = '\\)'
      end
    end

    class Renderer
      def initialize (regex, insertion)
        raise if regex == nil
        @regex = regex
        @meta = Metachars.new
        @insertion = insertion
        @with_paren = false
      end
      attr_accessor :with_paren

      def render
        if @with_paren  # e.g. "(a|b|c)"
          render0(@regex)
        else            # e.g. "a|b|c"
          @regex.map do |x|
            render0(x)
          end.join @meta.bar
        end
      end

      def join_regexes (string, regexes)
        ([string] + regexes).join @meta.bar
      end

      private
      def render_alternation (regex)
        if regex.length == 0
          raise
        elsif regex.length == 1
          render0(regex[0])
        else
          @meta.lparen + 
            regex.map {|x| render0(x) }.join(@meta.bar) + 
            @meta.rparen
        end
      end

      def render_concatnation (regex)
        regex.map {|x| render0(x) }.join(@insertion)
      end

      # We don't use Regexp.quote because the following regex
      # is more general (not ruby-specific) and safe to use.
      def escape_string (string)
        string.gsub(/([\x00-\x1f\x21-\x2f\x3a-\x40\x5b-\x5e\x60\x7b-\x7f])/, '\\\\\\1')
      end

      def escape_charclass (string)
        string.gsub(/\\/, '\\\\\\')
      end

      def render_charclass (regex)
        if regex.delete("-")
          regex.push("-")  # move "-" to the end of Array.
        end
        if regex.delete("]")
          regex.unshift("]")  # move "]" to the beginning of Array.
        end
        escape_charclass("[" + regex.join + "]")
      end

      def insert (string)
        if @insertion != ""
          tmp = string.gsub(/(\\.|.)/, "\\1#{@insertion}")
          tmp = tmp.sub(/#{Regexp.quote(@insertion)}$/, "")
        else
          string
        end
      end

      def render_string (regex)
        insert(escape_string(regex))
      end

      def render0 (x)
        if x.instance_of?(Alternation)
          render_alternation(x)
        elsif x.instance_of?(Concatnation)
          render_concatnation(x)
        elsif x.instance_of?(CharClass)
          render_charclass(x)
        elsif x.instance_of?(String)
          render_string(x)
        else
          raise "unexpected type: #{x} of #{x.class}"
        end
      end
    end

    class PerlRenderer < Renderer
      def initialize (regex, insertion)
        super(regex, insertion)
        @meta = PerlMetachars.new
      end
    end

    class RubyRenderer < PerlRenderer
    end

    class EgrepRenderer < Renderer
    end

    class EmacsRenderer < Renderer
      def initialize (regex, insertion)
        super(regex, insertion)
        @meta = EmacsMetachars.new
      end

      def escape_string (string)
        str = Regexp.quote(string)
        str.gsub!(/\\\(/, "(")
        str.gsub!(/\\\)/, ")")
        str.gsub!(/\\\|/, "|")
        str.gsub!(/\\\</, "<")
        str.gsub!(/\\\>/, ">")
        str.gsub!(/\\\=/, "=")
        str.gsub!(/\\\'/, "'")
        str.gsub!(/\\\`/, "`")
        str.gsub!(/\\\{/, "{")
        str
      end

      def escape_charclass (string)
        string
      end
    end

    module MetacharsFactory
      def new (type)
        case type
        when nil
          RubyMetachars.new
        when "emacs"
          EmacsMetachars.new
        when "perl"
          PerlMetachars.new
        when "ruby"
          RubyMetachars.new
        when "egrep"
          EgrepMetachars.new
        else
          raise "Unknown type: #{type}"
        end
      end
      module_function :new
    end

    module RendererFactory
      def new (regex, type, insertion)
        case type
        when nil
          RubyRenderer.new(regex, insertion)
        when "emacs"
          EmacsRenderer.new(regex, insertion)
        when "perl"
          PerlRenderer.new(regex, insertion)
        when "ruby"
          RubyRenderer.new(regex, insertion)
        when "egrep"
          EgrepRenderer.new(regex, insertion)
        else
          raise "Unknown type: #{regex}"
        end
      end
      module_function :new
    end
  end
end
