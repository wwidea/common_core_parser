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
      data.xpath('//Statements/Statement').first.text
    end

    def grade
      data.xpath('//GradeLevels/GradeLevel/Code').first.text
    end
    
    def to_s
      "ref_id: #{ref_id}, predecessor_ref_id: #{predecessor_ref_id}, code: #{code}, statement: #{statement}, grade: #{grade}"
    end
  end
end
