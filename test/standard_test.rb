#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

class StandardTest < Test::Unit::TestCase
  
  test "should return ref_id" do
    assert_equal '823405101A0842988705A4755FDF0C73', math_standard.ref_id
  end
  
  test "should return predecessor_ref_id" do
    assert_equal 'DC3CA9D4920144bcBC0B5A4B6A5BFB23', math_standard.predecessor_ref_id
  end
  
  test "should return code" do
    assert_equal 'Mathematics.1.NBT.2.a', math_standard.code
  end
  
  test "should return statement" do
    assert_equal '10 can be thought of as a bundle of ten ones—called a "ten".', math_standard.statement
  end
  
  test "should return grade" do
    assert_equal '01', math_standard.grade
  end
  
  test "should return string representation of standard" do
    assert_equal 'ref_id: 823405101A0842988705A4755FDF0C73, predecessor_ref_id: DC3CA9D4920144bcBC0B5A4B6A5BFB23, code: Mathematics.1.NBT.2.a, statement: 10 can be thought of as a bundle of ten ones—called a "ten"., grade: 01', math_standard.to_s
  end
  
private
  
  def math_standard
    CommonCore::Standard.new(math_standard_xml)
  end
  
  def math_standard_xml
    @math_standard_xml ||= Nokogiri::XML(File.read(File.expand_path('../data/math_standard.xml', __FILE__)))
  end
end
