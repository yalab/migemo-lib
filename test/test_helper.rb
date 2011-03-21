$LOAD_PATH << File.dirname(File.expand_path(__FILE__)) + '/../lib'
$LOAD_PATH << File.dirname(File.expand_path(__FILE__)) + '/../bin'
require 'test/unit'
require 'migemo'
require 'migemo-convert'
require 'migemo-index'
require 'migemo-chars'
require 'migemo-cache'

Test::Unit::TestCase.module_eval do
  def migemo_dict
    @dict ||= Migemo::Dict::Static.new(File.dirname(File.expand_path(__FILE__)) + '/../data/test-dict')
  end unless method_defined?(:migemo_dict)

  def user_dict
    @user_dict ||= Migemo::Dict::Users.new(File.dirname(File.expand_path(__FILE__)) + '/../data/user-dict.sample')
  end unless method_defined?(:user_dict)

  def regex_dict
    @regex_dict ||= Migemo::Dict::Users.new(File.dirname(File.expand_path(__FILE__)) + '/../data/regex-dict.sample')
  end unless method_defined?(:regex_dict)
end
