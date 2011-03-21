=begin
= Ruby/Migemo: ローマ字のまま日本語をインクリメンタル検索する Ruby用のライブラリ
Ruby/Migemo はローマ字のまま日本語をインクリメンタル検索する
ためのライブラリです。

=== 使用例

  % cat sample.rb
  require 'migemo'

  dict = Migemo::Dict::Static.new("migemo-dict")
  dict_cache  = Migemo::Dict::Cache.new("migemo-dict" + ".cache")
  user_dict = Migemo::Dict::Users.new("user-dict")

  while line = gets
    pattern = line.chomp
    migemo = Migemo.new(pattern,dict)
    migemo.optimization = 3
    migemo.dict_cache = dict_cache
    migemo.user_dict = user_dict
    migemo.type = "ruby"
    puts migemo.regex
  end

== API

--- Migemo::Dict::Static#new(filename)
    静的な辞書のオブジェクトを生成する

--- Migemo::Dict::Cache#new(filename)
    静的な辞書のキャッシュのオブジェクトを生成する

--- Migemo::Dict::Users#new(filename)
    ユーザ辞書のオブジェクトを生成する

--- Migemo#new(pattern, dict)
    Migemoオブジェクトを生成する。dict には
    Migemo::Dict::Static オブジェクトかStringを、pattern には検索パター
    ンを与える

--- Migemo#regex
    検索パターンを展開した正規表現の文字列を返す。

--- Migemo#type
    正規表現の種類 (emacs, ruby, perl) を設定する accessor。[ruby]

--- Migemo#dict_cache
    静的辞書のキャッシュを設定する accessor。

--- Migemo#usr_dict
    ユーザ辞書のオブジェクトを設定する accessor。

--- Migemo#regex_dict
    正規表現辞書のオブジェクトを設定する accessor。

--- Migemo#insertion
    1文字ごとに挟む文字列を設定する accessor。

--- Migemo#optimization
    正規表現のコンパクト化のレベル (0-3) を設定する accessor。[3]

satoru@namazu.org
=end
