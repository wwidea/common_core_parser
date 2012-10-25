module CommonCore
  class Element

    attr_accessor :data
    attr_reader :children

    def initialize(xmldoc)
      raise(ArgumentError, "Not a LearningStandardItem\n #{xmldoc}") unless xmldoc.name == 'LearningStandardItem'
      @data = xmldoc
      @children = {}
    end

    def to_s
      "<#{self.class} ref_id: #{ref_id}, parent_ref_id: #{parent_ref_id}, code: #{code}, statement: #{statement}, grades: #{grades.join(',')}>"
    end

    def ref_id
      @ref_id ||= BrokenDataCorrector.patch_duplicated_ref_ids(self,(data.attributes['RefID'] || data.attributes['RefId']).value.strip)
    end

    def parent
      @parent ||= Master.instance.elements[parent_ref_id]
    end

    def parent_ref_id
      return @parent_ref_id if @parent_ref_id

      #new file format
      data.xpath('./RelatedLearningStandardItems/LearningStandardItemRefId').each do |lsiri|
        return @parent_ref_id = BrokenDataCorrector.patch_duplicated_parent_ref_ids(self,lsiri.text.strip) if lsiri.attributes['RelationshipType'].value == 'childOf'
      end

      #old file format
      data.xpath('./PredecessorItems/LearningStandardItemRefId').each do |lsiri|
        return @parent_ref_id = BrokenDataCorrector.patch_duplicated_parent_ref_ids(self,lsiri.text.strip)
      end

      return nil
    end

    def add_child(element)
      children[element.ref_id] = element
    end

    def code
      @code ||= data.xpath('./StatementCodes/StatementCode').first.text.strip
    end

    def statement
      @statement ||= data.xpath('./Statements/Statement').first.text.strip
    end

    def grades
      @grades ||= data.xpath('./GradeLevels/GradeLevel').map(&:text).map {|string| string.match(/[A-Z]/) ? string : sprintf('%02d',string.to_i) }
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

    def illigit?
      return false unless ref_id.blank?
      case
        when (ref_id.blank? and statement.match(/not applicable/)) then true
        when (ref_id.blank? and statement.match(/begins in grade [0-9]+/)) then true
        else false
      end
    end

  end
end
