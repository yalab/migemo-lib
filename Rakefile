%w/test lib bin/.each do |lib|
  $LOAD_PATH << File.dirname(File.expand_path(__FILE__)) + "/#{lib}"
end
require 'rake/testtask'
require 'open-uri'
require 'fileutils'
require 'migemo'
require 'migemo-convert'
require 'migemo-index'
require 'migemo-chars'
require 'migemo-cache'

ROOT = File.dirname(File.expand_path(__FILE__))

SKK_DICT     = "data/SKK-JISYO.L"
MIGEMO_DICT  = 'data/migemo-dict'
MIGEMO_INDEX = 'data/migemo-dict.idx'
MIGEMO_CHARS = 'data/migemo-chars'
MIGEMO_CACHE = 'data/migemo-dict.cache'
MIGEMO_INDEX_CACHE = 'data/migemo-dict.cache.idx'
ELISP        = 'elisp/migemo.el'

RESOURCES = [MIGEMO_DICT, MIGEMO_INDEX, MIGEMO_CHARS, MIGEMO_CACHE, MIGEMO_INDEX_CACHE, ELISP]

task :default => :test
task :setup   => RESOURCES
task :clean do
  RESOURCES.each do |f|
    File.unlink(f) if File.exists?(f)
  end
end

task :test => RESOURCES do
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/*.rb']
    t.warning = true
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

file ELISP do |t|
  lisp_in = nil
  File.open(ELISP + '.in') do |f|
    lisp_in = f.read
  end
  lisp_in.gsub!(/@pkgdatadir@/, ROOT + '/data')
  File.open(ELISP, 'w') do |f|
    f.write(lisp_in)
  end
end
