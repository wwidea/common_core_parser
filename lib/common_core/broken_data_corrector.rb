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

      #######
      private
      #######

      # A few standards in the new xml files are are pointed to cluster ids that
      # don't exist in the old xml files. Point them to their old clusters for now
      # This shouldn't be necessary when corestandards.org makes a complete set of
      # updated xml files available.
      def correct_standards_pointed_to_missing_ref_ids(element)
        ref_id_map = {
          'B1AC98EADE4145689E70EEEBD9B8CC19' => 'B1AC98EADE4145689E70EEEBD9B8CC18',
          '834B17E279C64263AA83F7625F5D2994' => '834B17E279C64263AA83F7625F5D2993',
          '91FABAB899814C55851003A0EE98F8FC' => '91FABAB899814C55851003A0EE98F8FB'
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
        if element.ref_id == 'F053D3437D1E4338A2C18B25DACBED85'
          puts element
          puts element.code.match(/CCSS\.ELA\-Literacy\.L\./)
        end

        return unless (element.is_a?(CommonCore::Standard) and element.parent_ref_id.blank? and element.code.match(/CCSS\.ELA\-Literacy\.L\.3/))
        element.instance_variable_set(:@parent_ref_id,'INTENTIONALLYORPHANED')
      end
    end

  end
end