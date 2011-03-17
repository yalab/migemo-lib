$LOAD_PATH << File.dirname(File.expand_path(__FILE__)) + '/test'
require 'test_helper'
require 'rake/testtask'
require 'open-uri'
require 'fileutils'
ROOT = File.dirname(File.expand_path(__FILE__))

SKK_DICT     = "data/SKK-JISYO.L"
MIGEMO_DICT  = 'data/migemo-dict'
MIGEMO_INDEX = 'data/migemo-dict.idx'
MIGEMO_CHARS = 'data/migemo-chars'
MIGEMO_CACHE = 'data/migemo-dict.cache'

task :default => :test
task :setup   => [MIGEMO_DICT, MIGEMO_INDEX]
task :test => MIGEMO_DICT do
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/*.rb']
  end
end

task :clean do
  [SKK_DICT, MIGEMO_DICT].each do |f|
      File.unlink("#{ROOT}/#{f}")
  end
end

file SKK_DICT do |t|
  open("http://openlab.ring.gr.jp/skk/skk/dic/SKK-JISYO.L") do |dict|
    File.open("#{ROOT}/#{t.name}", "w") do |output|
      output.write(dict.read)
    end
  end
end

file MIGEMO_DICT => SKK_DICT do |t|
  lines = nil
  File.open(SKK_DICT, 'r:euc-jp') do |f|
    lines = f.read.encode("UTF-8")
  end
  io = File.open("#{ROOT}/#{t.name}", "w")

  Migemo::Convert.new(lines).output(io)
end

file MIGEMO_INDEX => MIGEMO_DICT do |t|
  Migemo::Index.new(File.open(MIGEMO_DICT)).convert.save(MIGEMO_INDEX)
end

file MIGEMO_CHARS => MIGEMO_DICT do |t|
  Migemo::Chars.new(MIGEMO_DICT).generate.save(MIGEMO_CHARS)
end

file MIGEMO_CACHE => [MIGEMO_CHARS, MIGEMO_DICT] do |t|
  Migemo::Cache.new(MIGEMO_DICT, MIGEMO_CHARS).generate.save(MIGEMO_CACHE)
end
