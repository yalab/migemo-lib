require './lib/migemo/version'
Gem::Specification.new do |spec|
  spec.authors  = ['Satoru Takabayashi', 'Atsushi Yoshida']
  spec.email    = 'rudeboyjet@gmail.com'
  spec.homepage = 'https://github.com/yalab/migemo'
  spec.name     = "migemo"
  spec.version  = Migemo::VERSION::STRING
  spec.files    = Dir.glob("{doc,lib,test}/**/*") + ['ChangeLog', 'README', 'AUTHORS'] + ['data/migemo-dict', 'data/migemo-dict.idx', 'data/migemo-dict.cache', 'data/migemo-dict.cache.idx']
  spec.license  = "Ruby's"
  spec.summary  = 'a tool for Japanese incremental search.'
  spec.description = <<EOS
Migemo is a tool for Japanese incremental search.
It makes Japanese character regular expression from alphabet and optimize them.
EOS
  spec.add_dependency('romkan', '>=0.4.0')
  spec.add_dependency('bsearch', '>=1.5.0')
end
