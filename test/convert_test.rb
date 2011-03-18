# -*- coding: utf-8 -*-
require 'test_helper'

class ConvertTest < Test::Unit::TestCase
  def test_convert
    input =<<-EOF
;;
;; This is a comment line.
;;
りかい /理解/
りかいs /理解/
motion /モーション/
りくとく /六徳;人が守るべき六つの徳。「ろくとく」とも/
EOF
    expects =<<-EOF
;;
;; This is Migemo's dictionary generated from SKK's.
;;
;;
;; This is a comment line.
;;
motion	モーション
りかい	理解
りくとく	六徳
EOF
    convert = Migemo::Convert.new(input)
    assert_equal expects,  (convert.header + convert.transfer).join("\n") + "\n"
  end
end
