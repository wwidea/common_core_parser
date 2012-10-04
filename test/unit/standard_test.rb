#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

class StandardTest < ActiveSupport::TestCase

  # ref_id
  test "should return ref_id" do
    assert_equal '823405101A0842988705A4755FDF0C73', math_standard.ref_id
  end


  # predecessor_ref_id
  test "should return predecessor_ref_id" do
    assert_equal 'DC3CA9D4920144bcBC0B5A4B6A5BFB23', math_standard.predecessor_ref_id
  end


  # code
  test "should return code" do
    assert_equal 'Mathematics.1.NBT.2.a', math_standard.code
  end


  # statement
  test "should return statement" do
    assert_equal '10 can be thought of as a bundle of ten ones—called a "ten".', math_standard.statement
  end


  # grades
  test "should return grades" do
    assert_equal ['01'], math_standard.grades
  end

  test "should return multiple grades" do
    assert_equal %w(09 10), ela_standard.grades
  end


  # to_s
  test "should return string representation of standard" do
    assert_equal 'ref_id: 823405101A0842988705A4755FDF0C73, predecessor_ref_id: DC3CA9D4920144bcBC0B5A4B6A5BFB23, code: Mathematics.1.NBT.2.a, statement: 10 can be thought of as a bundle of ten ones—called a "ten"., grade: 01', math_standard.to_s
  end


  # valid?
  test "should return true for valid?" do
    assert_equal true, math_standard.valid?
  end

  test "should return false for valid? when statement is blank" do
    math_standard.data.xpath('//Statements/Statement').first.inner_html = ''

    assert_equal false, math_standard.valid?
  end


  # valid_grades?
  test "should return true for valid_grades?" do
    assert_equal true, math_standard.valid_grades?
  end

  test "should return false for valid_grade? when out of range" do
    math_standard.data.xpath('//Statements/Statement').first.inner_html = ''
  end

private

  def math_standard
    CommonCore::Standard.new(math_standard_xml)
  end

  def math_standard_xml
    @math_standard_xml ||= Nokogiri::XML(File.read(File.expand_path('../../data/math_standard.xml', __FILE__)))
  end

  def ela_standard
    CommonCore::Standard.new(ela_standard_xml)
  end

  def ela_standard_xml
    @ela_standard_xml ||= Nokogiri::XML(File.read(File.expand_path('../../data/ela_standard.xml', __FILE__)))
  end
end
