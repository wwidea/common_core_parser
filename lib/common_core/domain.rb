module CommonCore
  class Domain < CommonCore::Element
    def to_s
      "ref_id: #{ref_id}, code: #{code}, statement: #{statement}, grade: #{grades * ','}"
    end
    
    def valid?
      !(ref_id.blank? || code.blank? || statement.blank?) && valid_grades?
    end
  end
end
