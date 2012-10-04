#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

class ElementTest < ActiveSupport::TestCase

  # to_s
  test "should raise RuntimeError for to_s" do
    assert_raise(RuntimeError) do
      CommonCore::Element.new(Nokogiri::XML(File.read(File.expand_path('../../data/math_standard.xml', __FILE__)))).to_s
    end
  end


  # valid?
  test "should raise RuntimeError for valid?" do
    assert_raise(RuntimeError) do
      CommonCore::Element.new(Nokogiri::XML(File.read(File.expand_path('../../data/math_standard.xml', __FILE__)))).valid?
    end
  end
end
