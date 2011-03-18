require 'test_helper'
class CacheTest < Test::Unit::TestCase
  def setup
    base_dir = File.dirname(File.expand_path(__FILE__))
    dict_file =  base_dir+ '/../data/test-dict'
    words = base_dir + '/../data/migemo-chars'
    File.open(dict_file) do |f|
      @words = f.readlines.map{|l| l =~ /^(\w).*?	/; $1 }.compact.uniq
    end
    unless File.exists?(dict_file + '.cache')
      Migemo::Cache.new(dict_file, words).generate.save(dict_file + '.cache')
    end
    @cache_dict = MigemoDictCache.new(dict_file + '.cache')
  end

  def test_caches
    @words.each do |w|
      [:normal, :cache].each do |ivar|
        migemo = Migemo.new(migemo_dict, w)
        migemo.user_dict = user_dict
        migemo.regex_dict = regex_dict
        instance_variable_set("@#{ivar}", migemo)
      end
      @cache.dict_cache = @cache_dict
      assert_equal @normal.regex, @cache.regex
    end
  end
end
