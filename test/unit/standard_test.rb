#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

module CommonCoreParser
  class StandardTest < ActiveSupport::TestCase

    # ref_id
    test "should return ref_id" do
      assert_equal 'CA9EE2E34F384E95A5FA26769C5864B8', math_standard.ref_id
    end


    # predecessor_ref_id
    test "should return predecessor_ref_id" do
      assert_equal '4F4106218F834258BCDDB7EB39806880', math_standard.parent_ref_id
    end


    # code
    test "should return code" do
      assert_equal 'CCSS.Math.Content.K.CC.A.1', math_standard.code
    end


    # statement
    test "should return statement" do
      assert_equal 'Count to 100 by ones and by tens.', math_standard.statement
    end


    # grades
    test "should return grades" do
      assert_equal ['K'], math_standard.grades
    end

    test "should return multiple grades" do
      assert_equal ["K", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"], ela_standard.grades
    end


    # to_s
    test "should return string representation of standard" do
      assert_equal '<CommonCoreParser::Standard ref_id: CA9EE2E34F384E95A5FA26769C5864B8, parent_ref_id: 4F4106218F834258BCDDB7EB39806880, code: CCSS.Math.Content.K.CC.A.1, statement: Count to 100 by ones and by tens., grades: K>', math_standard.to_s
    end


    # valid?
    test "should return true for valid?" do
      assert_equal true, math_standard.valid?
    end

    test "should return false for valid? when statement is blank" do
      saved_math_standard = math_standard
      saved_math_standard.stubs(:statement).returns('')
      assert_equal true, saved_math_standard.statement.blank?
      assert_equal false, saved_math_standard.valid?
    end


    # valid_grades?
    test "should return true for valid_grades?" do
      assert_equal true, math_standard.valid_grades?
    end

    #test "should return false for valid_grade? when out of range" do
    #  math_standard.data.xpath('//Statements/Statement').first.inner_html = ''
    #end

    #######
    private
    #######

    def math_standard
      Standard.new(math_standard_xml)
    end

    def math_standard_xml
      @math_standard_xml ||= Nokogiri::XML(File.read(DATA_PATH+'/Math.xml')).xpath('//LearningStandardItem').first
    end

    def ela_standard
      Standard.new(ela_standard_xml)
    end

    def ela_standard_xml
      @ela_standard_xml ||= Nokogiri::XML(File.read(DATA_PATH+'/ELA-Literacy.xml')).xpath('//LearningStandardItem').first
    end
  end
end