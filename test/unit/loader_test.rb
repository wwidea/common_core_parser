#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

module CommonCoreParser
  class LoaderTest < ActiveSupport::TestCase

    def setup
      @master = Master.instance
    end

    test "should load math standards from xml" do
      @master.load_math
      assert_equal 393, @master.standards.keys.length
      @master.standards.each do |key,standard|
        assert standard.is_a?(Standard), "#{standard} expected to be a Standard"
        assert standard.valid?, "#{standard.error_message} - #{standard}"
      end
    end

    test "should load ela standards from xml" do
      @master.load_ela
      assert_equal 574, @master.standards.keys.length
      @master.standards.each do |key,standard|
        assert standard.is_a?(Standard), "#{standard} expected to be a Standard"
        assert standard.valid?, "#{standard.error_message} - #{standard}"
      end
    end

    test 'should reinitialize when loading new data set' do
      @master.load_ela
      ela_count = @master.elements.size
      @master.load_math
      math_count = @master.elements.size
      assert math_count < ela_count
    end

    test "should load math standard components from xml" do
      @master.load_math
      assert_equal 124, @master.components.keys.length
      @master.components.each do |key,component|
        assert component.is_a?(Component), "#{component} expected to be a Component"
        assert component.valid?, "#{component.error_message} - #{component}"
      end
    end

    test "should load ela standard components from xml" do
      @master.load_ela
      assert_equal 445, @master.components.keys.length
      @master.components.each do |key,component|
        assert component.is_a?(Component), "#{component} expected to be a Component"
        assert component.valid?, "#{component.error_message} - #{component}"
      end
    end

    test "should load a single math domain from xml" do
      @master.load_elements_from_paths(DATA_PATH+'/Mathematics/Grade1/Domain/Math_Grade1_G.xml')
      assert_equal 1, @master.domains.keys.length
      @master.domains.each do |key,domain|
        assert domain.is_a?(Domain), "#{domain} expected to be a Domain"
        assert domain.valid?, "#{domain} - #{domain.error_message}"
      end
    end

    test "should load a single math cluster from xml" do
      @master.load_elements_from_paths(DATA_PATH+'/Mathematics/Grade1/Domain/Clusters/Math_Grade1_G_1.xml')
      assert_equal 1, @master.clusters.keys.length
      @master.clusters.each do |key,cluster|
        assert cluster.is_a?(Cluster), "#{cluster} expected to be a Cluster"
        assert cluster.valid?, "#{cluster} - #{cluster.error_message}"
      end
    end

    test "should load all xml files for grade 1 math" do
      @master.load_elements_from_paths(DATA_PATH+'/Mathematics/Grade1/**/*.xml')
      assert_equal 1, @master.subject_grades.keys.length
      assert_equal 4, @master.domains.keys.length
      assert_equal 11, @master.clusters.keys.length
      @master.subject_grades.each do |key,subject_grade|
        assert subject_grade.is_a?(SubjectGrade), "#{subject_grade} expected to be a SubjectGrade"
        assert subject_grade.valid?, "#{subject_grade} - #{subject_grade.error_message}"
      end
      @master.domains.each do |key,domain|
        assert domain.is_a?(Domain), "#{domain} expected to be a Domain"
        assert domain.valid?, "#{domain} - #{domain.error_message}"
      end
      @master.clusters.each do |key,cluster|
        assert cluster.is_a?(Cluster), "#{cluster} expected to be a Cluster"
        assert cluster.valid?, "#{cluster} - #{cluster.error_message}"
      end
    end

    test "should load all xml files for math" do
      @master.load_math
      assert_equal 393, @master.standards.keys.length
      assert_equal 124, @master.components.keys.length
      assert_equal 15, @master.subject_grades.keys.length
      assert_equal 65, @master.domains.keys.length
      assert_equal 148, @master.clusters.keys.length
      @master.subject_grades.each do |key,subject_grade|
        assert subject_grade.is_a?(SubjectGrade), "#{subject_grade} expected to be a SubjectGrade"
        assert subject_grade.valid?, "#{subject_grade} - #{subject_grade.error_message}"
      end
      @master.domains.each do |key,domain|
        assert domain.is_a?(Domain), "#{domain} expected to be a Domain"
        assert domain.valid?, "#{domain} - #{domain.error_message}"
      end
      @master.clusters.each do |key,cluster|
        assert cluster.is_a?(Cluster), "#{cluster} expected to be a Cluster"
        assert cluster.valid?, "#{cluster} - #{cluster.error_message}"
      end
    end

    test "should load all xml files for language arts" do
      @master.load_ela
      assert_equal 13, @master.subject_grades.keys.length
      assert_equal 74, @master.domains.keys.length
      assert_equal 1, @master.standard_types.keys.length
      @master.subject_grades.each do |key,subject_grade|
        assert subject_grade.is_a?(SubjectGrade), "#{subject_grade} expected to be a SubjectGrade"
        assert subject_grade.valid?, "#{subject_grade} - #{subject_grade.error_message}"
      end
      @master.domains.each do |key,domain|
        assert domain.is_a?(Domain), "#{domain} expected to be a Domain"
        assert domain.valid?, "#{domain} - #{domain.error_message}"
      end
      @master.standard_types.each do |key,standard_type|
        assert standard_type.is_a?(StandardType), "#{standard_type} expected to be a StandardType"
        assert standard_type.valid?,"#{standard_type} -#{standard_type.error_message}"
      end
    end

    test "should load all xml files for math and reunite parents with children" do
      @master.load_math
      orphan_elements = []
      @master.elements.each do |key,element|
        next unless (element.parent_ref_id and element.parent.nil?)
        next if element.parent_ref_id == 'INTENTIONALLYORPHANED'
        orphan_elements << element
      end
      assert_equal(0,orphan_elements.size, orphan_elements.map{|element| "#{element.class}:#{element.ref_id}"})
    end

    test 'math standards should have a sane hierarchy' do
      @master.load_math
      insane_standards = []
      @master.standards.each do |key,standard|
        next if standard.parent_ref_id == 'INTENTIONALLYORPHANED'
        insanity_flag_raised = false

        insanity_flag_raised = true if standard.children.any? { |ref_id,child| ! child.is_a?(Component) }
        insanity_flag_raised = true unless insanity_flag_raised or standard.parent.is_a?(Cluster)
        insanity_flag_raised = true unless insanity_flag_raised or standard.parent.parent.is_a?(Domain)
        insanity_flag_raised = true unless insanity_flag_raised or standard.parent.parent.parent.is_a?(SubjectGrade)

        insane_standards << standard if insanity_flag_raised
      end
      assert_equal(0,insane_standards.size, insane_standards.map{|standard| "#{standard.ref_id}::#{standard.code}:#{standard.parent.class}:#{standard.parent_ref_id}"})
    end

    test 'languange arts standards should have sane hierarchy' do
      @master.load_ela
      insane_standards = []
      @master.standards.each do |key,standard|
        next if standard.parent_ref_id == 'INTENTIONALLYORPHANED'
        insanity_flag_raised = false

        insanity_flag_raised = true if standard.children.any? { |ref_id,child| ! child.is_a?(Component) }
        insanity_flag_raised = true unless insanity_flag_raised or standard.parent.is_a?(Domain)
        insanity_flag_raised = true unless insanity_flag_raised or standard.parent.parent.is_a?(SubjectGrade)

        insane_standards << standard if insanity_flag_raised
      end
      assert_equal(0,insane_standards.size, insane_standards.map{|standard| "#{standard} === #{standard.parent_ref_id.blank?}=== #{standard.code.match(/CCSS\.ELA\-Literacy\.L\.3/)}"})
    end

    test 'elements should never have unclosed html tags or start with a closing html tag' do
      @master.load_elements_from_paths(DATA_PATH+'/**/*.xml')
      failing_elements = []
      @master.elements.each do |key,element|
        failing_elements << element if element.statement.match(/^<\//)
        failing_elements << element if has_unclosed_html_tags?(element.statement)
      end
      assert_equal(0,failing_elements.size, failing_elements.map{|element| element.ref_id })
    end

    #######
    private
    #######

    def has_unclosed_html_tags?(string)
      [:i, :sup].each do |tag|
        opens = string.match(/<#{tag}>/)
        closes = string.match(/<\/#{tag}>/)
        return false if opens.nil?
        return true if closes.nil? or (opens.size == closes.size + 1)
        raise "too many unclosed open <#{tag}> tags to deal with" if opens.size > closes.size + 1 # just in case this becomes an issue in the future so it can be identified immediately
      end
      return false
    end
  end
end