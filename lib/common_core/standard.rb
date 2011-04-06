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
      data.xpath('//LearningStandardItem/PredecessorItems/LearningStandardItemRefId').first.text
    end

    def code
      data.xpath('//LearningStandardItem/StatementCodes/StatementCode').first.text
    end

    def statement
      data.xpath('//LearningStandardItem/Statements/Statement').first.text.strip
    end

    def grades
      data.xpath('//LearningStandardItem/GradeLevels/GradeLevel/Code').map(&:text)
    end
    
    def to_s
      "ref_id: #{ref_id}, predecessor_ref_id: #{predecessor_ref_id}, code: #{code}, statement: #{statement}, grade: #{grades * ','}"
    end
    
    def valid?
      !(ref_id.blank? || predecessor_ref_id.blank? || code.blank? || statement.blank?) && valid_grades?
    end
    
    def valid_grades?
      (grades & %w(KG 01 02 03 04 05 06 07 08 09 10 11 12)) == grades
    end
  end
end
