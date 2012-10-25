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
      @ref_id ||= patch_duplicated_ref_ids((data.attributes['RefID'] || data.attributes['RefId']).value.strip)
    end

    def parent
      @parent ||= Master.instance.elements[parent_ref_id]
    end

    def parent_ref_id
      return @parent_ref_id if @parent_ref_id

      #new file format
      data.xpath('./RelatedLearningStandardItems/LearningStandardItemRefId').each do |lsiri|
        return @parent_ref_id = patch_duplicated_parent_ref_ids(lsiri.text.strip) if lsiri.attributes['RelationshipType'].value == 'childOf'
      end

      #old file format
      data.xpath('./PredecessorItems/LearningStandardItemRefId').each do |lsiri|
        return @parent_ref_id = patch_duplicated_parent_ref_ids(lsiri.text.strip)
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

    #######
    private
    #######

    # There are a couple cases where an ELA Standard and Domain are sharing
    # the same ref_id, and three cases where two clusters are sharing the same
    # ref_id. This patch corrects the ref_ids to remove conflucts.
    # See also patch_duplicated_parent_ref_ids()
    def patch_duplicated_ref_ids(candidate_ref_id)
      flagged_standard_ref_ids = ['7CB154907B5743c7B97BFCFF452D7977','F053D3437D1E4338A2C18B25DACBED85']
      flagged_cluster_ref_ids = ['B1AC98EADE4145689E70EEEBD9B8CC18','834B17E279C64263AA83F7625F5D2993','91FABAB899814C55851003A0EE98F8FB']
      if flagged_standard_ref_ids.include?(candidate_ref_id) and self.is_a?(CommonCore::Standard)
        return "Standard:DUPLICATEDREF_ID:#{candidate_ref_id}"
      elsif flagged_cluster_ref_ids.include?(candidate_ref_id) and self.is_a?(CommonCore::Cluster)
        return "Cluster:DUPLICATEDREF_ID:#{candidate_ref_id}:#{self.code}"
      else
        return candidate_ref_id
      end
    end

    # There are a couple cases where an ELA Standard and Domain are sharing
    # the same ref_id, and three cases where two clusters are sharing the same
    # ref_id. This patch children's parent_ref_ids so that they still point to
    # the correct parent.
    # See also patch_duplicated_ref_ids()
    def patch_duplicated_parent_ref_ids(candidate_parent_ref_id)
      flagged_cluster_ref_ids = ['B1AC98EADE4145689E70EEEBD9B8CC18','834B17E279C64263AA83F7625F5D2993','91FABAB899814C55851003A0EE98F8FB']
      if candidate_parent_ref_id == 'F053D3437D1E4338A2C18B25DACBED85' and self.is_a?(CommonCore::Component)
        return "Standard:DUPLICATEDREF_ID:#{candidate_parent_ref_id}"
      elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and self.is_a?(CommonCore::Standard) and self.code.match(/\.K\.G\./)
        return "Cluster:DUPLICATEDREF_ID:#{candidate_parent_ref_id}:Mathematics.K.G.1"
      else
        return candidate_parent_ref_id
      end
    end
  end
end
