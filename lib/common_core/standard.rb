#!/usr/bin/env ruby
# encoding: UTF-8

module CommonCore
  class Standard < CommonCore::Element
    def to_s
      "ref_id: #{ref_id}, predecessor_ref_id: #{predecessor_ref_id}, code: #{code}, statement: #{statement}, grade: #{grades * ','}"
    end
    
    def valid?
      !(ref_id.blank? || predecessor_ref_id.blank? || code.blank? || statement.blank?) && valid_grades?
    end
  end
end
