project(
  'simple',
  'c',
  meson_version : '>= 1.3.0',
  version : '0.1',
  default_options : ['warning_level=3'],
)

dependencies = [
]

incdir = include_directories('subdir')

exe = executable(
  'simple',
  'simple.c',
  'subdir/foo.c',
  include_directories : incdir,
  dependencies : dependencies,
  install : true,
)

test('basic', exe)
