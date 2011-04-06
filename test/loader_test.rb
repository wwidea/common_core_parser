#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

class LoaderTest < Test::Unit::TestCase

  test "should load math standards" do
    standards = CommonCore::Loader.math_standards
    
    assert_equal 316, standards.length
    standards.each { |standard| assert standard.valid? }
  end
end
