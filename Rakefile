$LOAD_PATH << File.dirname(File.expand_path(__FILE__)) + '/test'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*.rb']
end
