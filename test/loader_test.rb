#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

class LoaderTest < Test::Unit::TestCase

  # math_standards
  test "should load math standards" do
    standards = CommonCore::Loader.math_standards
    
    assert_equal 293, standards.length
    standards.each { |standard| assert standard.valid? }
  end
  

  # math_domains
  test "should load math domains" do
    domains = CommonCore::Loader.math_domains
    
    assert_equal 38, domains.length
    domains.each { |domain| assert domain.valid? }
  end
  
  
  # ela_standards
  test "should load ela standards" do
    standards = CommonCore::Loader.ela_standards
    
    assert_equal 1019, standards.length
    standards.each { |standard| assert(standard.valid?, standard.to_s) }
  end
  
  
  # ela_domains
  test "should load ela domains" do
    domains = CommonCore::Loader.ela_domains
    
    assert_equal 74, domains.length
    domains.each { |domain| assert domain.valid? }
  end
end
