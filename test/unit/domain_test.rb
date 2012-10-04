#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

class DomainTest < ActiveSupport::TestCase

  # initialize
  test "should raise argument error" do
    assert_raise(ArgumentError) do
      CommonCore::Domain.new(Nokogiri::XML(File.read(File.expand_path('../../data/Math_Common_core_standards.xml', __FILE__))))
    end
  end

  # to_s
  test "should return string representation of domain" do
    assert_equal 'ref_id: AC5E5FD01F4E41A1987EF969EAAF02BE, code: Mathematics.G, statement: Geometry, grade: KG,01,02,03,04,05,06,07,08', math_domain.to_s
  end


  # valid?
  test "should return true for valid?" do
    assert_equal true, math_domain.valid?
  end

  test "should return false for valid? when statement is blank" do
    math_domain.data.xpath('//Statements/Statement').first.inner_html = ''

    assert_equal false, math_domain.valid?
  end

private

  def math_domain
    CommonCore::Domain.new(math_domain_xml)
  end

  def math_domain_xml
    @math_domain_xml ||= Nokogiri::XML(File.read(File.expand_path('../../data/math_domain.xml', __FILE__)))
  end
end
