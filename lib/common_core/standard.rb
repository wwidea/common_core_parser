#!/usr/bin/env ruby
# encoding: UTF-8

module CommonCore
  class Standard
    
    attr_accessor :data
    
    def initialize(string)
      self.data = string
    end
    
    def ref_id
      data.xpath('//LearningStandardItem').first.attributes['RefId'].value
    end

    def predecessor_ref_id
      data.xpath('//PredecessorItems/LearningStandardItemRefId').first.text
    end

    def code
      data.xpath('//StatementCodes/StatementCode').first.text
    end

    def statement
      data.xpath('//Statements/Statement').first.text.strip
    end

    def grade
      data.xpath('//GradeLevels/GradeLevel/Code').first.text
    end
    
    def to_s
      "ref_id: #{ref_id}, predecessor_ref_id: #{predecessor_ref_id}, code: #{code}, statement: #{statement}, grade: #{grade}"
    end
    
    def valid?
      !(ref_id.blank? || predecessor_ref_id.blank? || code.blank? || statement.blank?) && valid_grade?
    end
    
    def valid_grade?
      %w(KG 01 02 03 04 05 06 07 08 09 10 11 12).include?(grade)
    end
  end
end
