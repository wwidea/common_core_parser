#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

class DomainTest < Test::Unit::TestCase
  
  test "should raise argument error" do
    assert_raise(ArgumentError) do
      CommonCore::Domain.new(Nokogiri::XML(File.read(File.expand_path('../data/Math_Common_core_standards.xml', __FILE__))))
    end
  end
end
