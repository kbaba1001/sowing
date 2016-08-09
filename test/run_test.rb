#!/usr/bin/env ruby

require 'pathname'

base_dir = Pathname(File.dirname(__FILE__)).join('..').expand_path
lib_dir  = base_dir.join('lib')
test_dir = base_dir.join('test')

$LOAD_PATH.unshift(lib_dir)
# $VERBOSE = true
$KCODE = "utf8" unless "".respond_to?(:encoding)

require 'test/unit'
Dir[test_dir.join('fixtures/models/*.rb')].each {|f| require f }

exit Test::Unit::AutoRunner.run(true, test_dir)
