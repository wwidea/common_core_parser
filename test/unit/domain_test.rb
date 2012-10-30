#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

module CommonCoreParser
  class DomainTest < ActiveSupport::TestCase

    # to_s
    test "should return string representation of domain" do
      assert_equal '<CommonCoreParser::Domain ref_id: 4246B738DA224018B6D20C12F9ED0073, parent_ref_id: C235350E091D437FBE2794CE93FBE949, code: Mathematics.1.G, statement: Geometry, grades: 01>', math_domain.to_s
    end

    # valid?
    test "should return true for valid?" do
      assert_equal true, math_domain.valid?
    end

    test "should return false for valid? when statement is blank" do
      saved_math_domain = math_domain
      saved_math_domain.stubs(:statement).returns('')
      assert_equal true, saved_math_domain.statement.blank?
      assert_equal false, saved_math_domain.valid?
    end

    test 'should return repdecessor ref id' do
      assert_equal('C235350E091D437FBE2794CE93FBE949',math_domain.parent_ref_id)
    end

  private

    def math_domain
      Domain.new(math_domain_xml)
    end

    def math_domain_xml
      @math_domain_xml ||= Nokogiri::XML(File.read(DATA_PATH+'/Mathematics/Grade1/Domain/Math_Grade1_G.xml')).xpath('//LearningStandardItem').first
    end
  end
end