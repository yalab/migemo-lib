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
    @dict ||= MigemoStaticDict.new(File.dirname(File.expand_path(__FILE__)) + '/test-dict')
  end

  def user_dict
    @user_dict ||= MigemoUserDict.new(File.dirname(File.expand_path(__FILE__)) + '/../data/user-dict.sample')
  end

  def regex_dict
    @regex_dict ||= MigemoRegexDict.new(File.dirname(File.expand_path(__FILE__)) + '/../data/regex-dict.sample')
  end
end
