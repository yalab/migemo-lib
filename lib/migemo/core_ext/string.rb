# -*- coding: utf-8 -*-
class String
  # Hiragana to Katakana
  def to_katakana
    self.gsub(/う゛/, 'ヴ').tr('ぁ-ん', 'ァ-ン')
  end

  def first
    /^(\\.|.)/ =~ self
    $1
  end

  def last
    /(\\.|.)$/ =~ self
    $1
  end

  def rest
    /^(\\.|.)(.*)/ =~ self
    $2
  end

  HANZEN_TAB = {
    " " => "　", "!" => "！", '"' => "”", "#" => "＃", 
    "\$" => "＄", "%" => "％", "&" => "＆", "'" => "’",
    "(" => "（", ")" => "）", "*" => "＊", "+" => "＋",
    "," => "，", "-" => "−", "." => "．", "/" => "／",
    "0" => "０", "1" => "１", "2" => "２", "3" => "３",
    "4" => "４", "5" => "５", "6" => "６", "7" => "７",
    "8" => "８", "9" => "９", ":" => "：", ";" => "；",
    "<" => "＜", "=" => "＝", ">" => "＞", "?" => "？",
    '@' => "＠", "A" => "Ａ", "B" => "Ｂ", "C" => "Ｃ",
    "D" => "Ｄ", "E" => "Ｅ", "F" => "Ｆ", "G" => "Ｇ",
    "H" => "Ｈ", "I" => "Ｉ", "J" => "Ｊ", "K" => "Ｋ",
    "L" => "Ｌ", "M" => "Ｍ", "N" => "Ｎ", "O" => "Ｏ",
    "P" => "Ｐ", "Q" => "Ｑ", "R" => "Ｒ", "S" => "Ｓ",
    "T" => "Ｔ", "U" => "Ｕ", "V" => "Ｖ", "W" => "Ｗ",
    "X" => "Ｘ", "Y" => "Ｙ", "Z" => "Ｚ", "[" => "［", 
    "\\" => "＼", "]" => "］", "^" => "＾", "_" => "＿",
    "`" => "‘", "a" => "ａ", "b" => "ｂ", "c" => "ｃ",
    "d" => "ｄ", "e" => "ｅ", "f" => "ｆ", "g" => "ｇ",
    "h" => "ｈ", "i" => "ｉ", "j" => "ｊ", "k" => "ｋ",
    "l" => "ｌ", "m" => "ｍ", "n" => "ｎ", "o" => "ｏ",
    "p" => "ｐ", "q" => "ｑ", "r" => "ｒ", "s" => "ｓ",
    "t" => "ｔ", "u" => "ｕ", "v" => "ｖ", "w" => "ｗ",
    "x" => "ｘ", "y" => "ｙ", "z" => "ｚ", "{" => "｛",
    "|" => "｜", "}" => "｝", "~" => "‾"} #'

  HANZEN_RE = Regexp.new(HANZEN_TAB.keys.sort.map {|x| 
                           Regexp.quote(x)
                         }.join('|'))

  def to_fullwidth
    self.gsub(HANZEN_RE) {|s| HANZEN_TAB[s]}
  end
end
