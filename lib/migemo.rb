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
require 'migemo/regex'
require 'migemo/version'
require 'romkan'


module Migemo
end
def Migemo.new(pattern, dict=nil)
  Migemo::Regex.new(pattern, dict)
end
