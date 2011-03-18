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

#
# Convert a SKK's dictionary into Migemo's.
#
require 'romkan'
class Migemo
  class Convert
    HIRAGANA = "[ぁ-んー〜]"
    KANJI = "[亜-瑤]"
    HEADER = <<-EOS.gsub(/^ +/, '')
      ;;
      ;; This is Migemo's dictionary generated from SKK's.
      ;;
    EOS
    attr_reader :header
    def initialize(lines)
      lines = lines.split("\n") if lines.is_a?(String)
      (comments, lines) = lines.partition{|line| line =~ /^;/ }
      @header = HEADER.split("\n") + comments
      @body = lines
    end

    def transfer
      dict = [];
      @body.map do |line|
        next if /^(#{HIRAGANA}+)[a-z]? (.*)/ !~ line && /^(\w+) (.*)/ !~ line
        head = $1
        words = $2.split('/').map {|x|
          # remove annotations and elisp codes
          x.sub(/;.*/, "").sub(/^\((\w+)\b.+\)$/, "")
        }.delete_if {|x| x == ""}
        sprintf("%s\t%s", head, words.join("\t"))
      end.compact.sort.uniq
    end

    def output(io=nil)
      io = STDOUT unless io
      io.puts header
      io.puts transfer
    end
  end
end

Migemo::Convert.new(readlines).output if $0 == __FILE__
