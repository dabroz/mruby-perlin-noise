MRuby::Gem::Specification.new('mruby-perlin-noise') do |spec|
  spec.license = 'MIT'
  spec.authors = ['Junegunn Choi', 'Matthew Johnston', 'Tomasz Dabrowski']
  spec.summary = 'Perlin noise generator for mruby'
  spec.version = '0.1.0'
  spec.add_dependency 'mruby-enumerator', core: 'mruby-enumerator'
  spec.add_dependency 'mruby-random', core: 'mruby-random'
  spec.add_dependency 'mruby-hash-ext', core: 'mruby-hash-ext'
  spec.add_dependency 'mruby-proc-ext', core: 'mruby-proc-ext'
  spec.add_dependency 'mruby-matrix', github: 'dabroz/mruby-matrix'
end
