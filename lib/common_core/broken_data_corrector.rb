module CommonCore
  class BrokenDataCorrector

    class << self
      def run
        Master.instance.elements.dup.each do |ref_id,element|
          self.private_methods.select { |method_name| method_name.to_s.match(/^correct_/) }.each do |corrector_method|
            self.send(corrector_method,element)
          end
        end
      end

      # There are a some cases where multiple items are sharing the same ref_id.
      # * Two cases of an ELA Standard and Domain having the same ref_id.
      # * Three cases of pairs of clusters sharing the same ref_id.
      # * Two standards that both have the same ref_id
      # This patch corrects the ref_ids to remove conflucts.
      # See also patch_duplicated_parent_ref_ids()
      def patch_duplicated_ref_ids(element,candidate_ref_id)
        flagged_standard_domain_ref_ids = ['7CB154907B5743c7B97BFCFF452D7977','F053D3437D1E4338A2C18B25DACBED85']
        flagged_cluster_ref_ids = ['B1AC98EADE4145689E70EEEBD9B8CC18','834B17E279C64263AA83F7625F5D2993','91FABAB899814C55851003A0EE98F8FB']
        flagged_duplicated_stadard_ref_ids = ['FBCBB7C696FE475695920CA622B1C857']
        if flagged_standard_domain_ref_ids.include?(candidate_ref_id) and element.is_a?(CommonCore::Standard)
          return "Standard:DUPLICATEDREF_ID:#{candidate_ref_id}"
        elsif flagged_cluster_ref_ids.include?(candidate_ref_id) and element.is_a?(CommonCore::Cluster)
          return "Cluster:DUPLICATEDREF_ID:#{candidate_ref_id}:#{element.code}"
        elsif flagged_duplicated_stadard_ref_ids.include?(candidate_ref_id) and element.is_a?(CommonCore::Standard)
          return "Standard:DUPLICATEDREF_ID:#{candidate_ref_id}:#{element.code}"
        else
          return candidate_ref_id
        end
      end

      # See comments on patch_duplicated_ref_ids() above.
      def patch_duplicated_parent_ref_ids(element,candidate_parent_ref_id)
        flagged_cluster_ref_ids = ['B1AC98EADE4145689E70EEEBD9B8CC18','834B17E279C64263AA83F7625F5D2993','91FABAB899814C55851003A0EE98F8FB']
        if candidate_parent_ref_id == 'F053D3437D1E4338A2C18B25DACBED85' and element.is_a?(CommonCore::Component)
          return "Standard:DUPLICATEDREF_ID:#{candidate_parent_ref_id}"
        elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and element.is_a?(CommonCore::Standard) and element.code.match(/\.K\.G\./)
          return "Cluster:DUPLICATEDREF_ID:#{candidate_parent_ref_id}:Mathematics.K.G.1"
        elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and element.is_a?(CommonCore::Standard) and element.code == 'CCSS.Math.Content.K.MD.B.3'
          return "Cluster:DUPLICATEDREF_ID:#{candidate_parent_ref_id}:Mathematics.K.MD.2"
        elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and element.is_a?(CommonCore::Standard) and element.code.match(/\.3\.G\.A\./)
          return "Cluster:DUPLICATEDREF_ID:#{candidate_parent_ref_id}:Mathematics.3.G.1"
        elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and element.is_a?(CommonCore::Standard) and element.code == 'CCSS.Math.Content.6.NS.A.1'
          return "Cluster:DUPLICATEDREF_ID:#{candidate_parent_ref_id}:Mathematics.6.NS.1"
        elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and element.is_a?(CommonCore::Standard) and element.code.match(/\.3\.MD\.C\./)
          return "Cluster:DUPLICATEDREF_ID:#{candidate_parent_ref_id}:Mathematics.3.MD.3"
        elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and element.is_a?(CommonCore::Standard) and element.code.match(/\.6\.RP\.A\./)
          return "Cluster:DUPLICATEDREF_ID:#{candidate_parent_ref_id}:Mathematics.6.RP.1"
        else
          return candidate_parent_ref_id
        end
      end

      #######
      private
      #######

      # A few standards in the new xml files are are pointed to cluster ids that
      # don't exist in the old xml files. Point them to their old clusters for now
      # This shouldn't be necessary when corestandards.org makes a complete set of
      # updated xml files available.
      def correct_standards_pointed_to_missing_ref_ids(element)
        ref_id_map = {
          'B1AC98EADE4145689E70EEEBD9B8CC19' => patch_duplicated_parent_ref_ids(element,'B1AC98EADE4145689E70EEEBD9B8CC18'),
          '834B17E279C64263AA83F7625F5D2994' => patch_duplicated_parent_ref_ids(element,'834B17E279C64263AA83F7625F5D2993'),
          '91FABAB899814C55851003A0EE98F8FC' => patch_duplicated_parent_ref_ids(element,'91FABAB899814C55851003A0EE98F8FB')
        }
        return unless (element.is_a?(CommonCore::Standard) and ref_id_map.keys.include?(element.parent_ref_id))
        element.instance_variable_set(:@parent_ref_id,ref_id_map[element.parent_ref_id])
      end

      # The "Standards for Mathematical Practice" point to each other instead of
      # a cluster or domain.  WTF? Let's just orphanize them for now.
      def correct_parent_ref_id_for_practice_standards(element)
        return unless (element.is_a?(CommonCore::Standard) and element.code.match(/CCSS\.Math\.Practice\.MP[0-9]+/))
        element.instance_variable_set(:@parent_ref_id,'INTENTIONALLYORPHANED')
      end

      # The ELA "Anchor Standards" don't have a parent in the xml.
      # Flagging as intentionally orphaned until it gets corrected.
      def correct_ela_anchor_standards(element)
        return unless (element.is_a?(CommonCore::Standard) and element.parent_ref_id.blank? and element.code.match(/CCSS\.ELA\-Literacy\.CCRA.[RWSL]+\.[0-9]+/))
        element.instance_variable_set(:@parent_ref_id,'INTENTIONALLYORPHANED')
      end

      # The ELA Grade 3 "Language" Standards don't have a parent in the xml.
      # Flagging as intentionally orphaned until it gets corrected.
      def correct_ela_grade_3_language_standards(element)
        return unless (element.is_a?(CommonCore::Standard) and element.parent_ref_id.blank? and element.code.match(/CCSS\.ELA\-Literacy\.L\.3/))
        element.instance_variable_set(:@parent_ref_id,'INTENTIONALLYORPHANED')
      end
    end

  end
end