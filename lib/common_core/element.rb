module CommonCore
  class Element

    attr_accessor :data

    def initialize(xmldoc)
      xmldoc = Nokogiri::XML(xmldoc) unless xmldoc.is_a?(Nokogiri::XML::Element)
      # ensure LearningStandardItem root is present
      raise(ArgumentError, "Not a LearningStandardItem\n #{xmldoc}") unless xmldoc.name == 'LearningStandardItem'
      self.data = xmldoc
    end

    def to_s
      "<#{self.class} ref_id: #{ref_id}, predecessor_ref_id: #{predecessor_ref_id}, code: #{code}, statement: #{statement}, grades: #{grades.join(',')}>"
    end

    def ref_id
      case
        when data.attributes['RefID'] then data.attributes['RefID'].value
        when data.attributes['RefId'] then data.attributes['RefId'].value
      end
    end

    def predecessor_ref_id

      data.xpath('./RelatedLearningStandardItems/LearningStandardItemRefId').each do |lsiri|
        return lsiri.text if lsiri.attributes['RelationshipType'].value == 'childOf'
      end

      data.xpath('./PredecessorItems/LearningStandardItemRefId').each do |lsiri|
        return lsiri.text
      end

      return nil
    end

    def code
      data.xpath('./StatementCodes/StatementCode').first.text
    end

    def statement
      data.xpath('./Statements/Statement').first.text.strip
    end

    def grades
      data.xpath('./GradeLevels/GradeLevel').map(&:text).map {|string| string.match(/[A-Z]/) ? string : sprintf('%02d',string.to_i) }
    end

    def valid_grades?
      (grades & %w(K HS K-12 01 02 03 04 05 06 07 08 09 10 11 12)) == grades
    end

    def valid?
      errors.blank?
    end

    def errors
      raise RuntimeError
    end

    def error_message
      errors.join(',')
    end
  end
end
