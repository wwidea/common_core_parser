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
    end

  end
end