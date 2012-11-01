module CommonCoreParser
  class BrokenDataCorrector

    class << self
      def run
        Master.instance.elements.each do |element|
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
        if candidate_ref_id == 'F053D3437D1E4338A2C18B25DACBED85' and element.is_a?(Standard)
          return "Standard:DUPLICATEDREF_ID:#{candidate_ref_id}"
        elsif candidate_ref_id == 'F053D3437D1E4338A2C18B25DACBED85' and element.is_a?(Domain)
          return "Domain:DUPLICATEDREF_ID:#{candidate_ref_id}"
        elsif flagged_standard_domain_ref_ids.include?(candidate_ref_id) and element.is_a?(Standard)
          return "Standard:DUPLICATEDREF_ID:#{candidate_ref_id}"
        elsif flagged_cluster_ref_ids.include?(candidate_ref_id) and element.is_a?(Cluster)
          return "Cluster:DUPLICATEDREF_ID:#{candidate_ref_id}:#{element.code}"
        elsif flagged_duplicated_stadard_ref_ids.include?(candidate_ref_id) and element.is_a?(Standard)
          return "Standard:DUPLICATEDREF_ID:#{candidate_ref_id}:#{element.code}"
        else
          return candidate_ref_id
        end
      end

      # See comments on patch_duplicated_ref_ids() above.
      def patch_duplicated_parent_ref_ids(element,candidate_parent_ref_id)
        flagged_cluster_ref_ids = ['B1AC98EADE4145689E70EEEBD9B8CC18','834B17E279C64263AA83F7625F5D2993','91FABAB899814C55851003A0EE98F8FB']
        if candidate_parent_ref_id == 'F053D3437D1E4338A2C18B25DACBED85' and element.is_a?(Component)
          return "Standard:DUPLICATEDREF_ID:#{candidate_parent_ref_id}"
        elsif candidate_parent_ref_id == 'F053D3437D1E4338A2C18B25DACBED85' and element.is_a?(Standard)
          return "Domain:DUPLICATEDREF_ID:#{candidate_parent_ref_id}"
        elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and element.is_a?(Standard) and element.code.match(/\.K\.G\./)
          return "Cluster:DUPLICATEDREF_ID:#{candidate_parent_ref_id}:Mathematics.K.G.1"
        elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and element.is_a?(Standard) and element.code == 'CCSS.Math.Content.K.MD.B.3'
          return "Cluster:DUPLICATEDREF_ID:#{candidate_parent_ref_id}:Mathematics.K.MD.2"
        elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and element.is_a?(Standard) and element.code.match(/\.3\.G\.A\./)
          return "Cluster:DUPLICATEDREF_ID:#{candidate_parent_ref_id}:Mathematics.3.G.1"
        elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and element.is_a?(Standard) and element.code == 'CCSS.Math.Content.6.NS.A.1'
          return "Cluster:DUPLICATEDREF_ID:#{candidate_parent_ref_id}:Mathematics.6.NS.1"
        elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and element.is_a?(Standard) and element.code.match(/\.3\.MD\.C\./)
          return "Cluster:DUPLICATEDREF_ID:#{candidate_parent_ref_id}:Mathematics.3.MD.3"
        elsif flagged_cluster_ref_ids.include?(candidate_parent_ref_id) and element.is_a?(Standard) and element.code.match(/\.6\.RP\.A\./)
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
        return unless (element.is_a?(Standard) and ref_id_map.keys.include?(element.parent_ref_id))
        element.instance_variable_set(:@parent_ref_id,ref_id_map[element.parent_ref_id])
      end

      # The "Standards for Mathematical Practice" point to each other instead of
      # a cluster or domain.  WTF? Let's just orphanize them for now.
      def correct_parent_ref_id_for_practice_standards(element)
        return unless (element.is_a?(Standard) and element.code.match(/CCSS\.Math\.Practice\.MP[0-9]+/))
        element.instance_variable_set(:@parent_ref_id,'INTENTIONALLYORPHANED')
      end

      # The ELA "Anchor Standards" don't have a parent in the xml.
      # Flagging as intentionally orphaned until it gets corrected.
      def correct_ela_anchor_standards(element)
        return unless (element.is_a?(Standard) and element.parent_ref_id.blank? and element.code.match(/CCSS\.ELA\-Literacy\.CCRA.[RWSL]+\.[0-9]+/))
        element.instance_variable_set(:@parent_ref_id,'INTENTIONALLYORPHANED')
      end

      # The ELA Grade 3 "Language" Standards don't have a parent in the xml.
      # Point them to the correct Domain
      def correct_ela_grade_3_language_standards(element)
        return unless (element.is_a?(Standard) and element.parent_ref_id.blank? and element.code.match(/CCSS\.ELA\-Literacy\.L\.3/))
        element.instance_variable_set(:@parent_ref_id,patch_duplicated_parent_ref_ids(element,'F053D3437D1E4338A2C18B25DACBED85'))
      end

      def correct_unnecessarily_unicoded_characters(element)
        # http://www.htmlescape.net/unicode_chart_general_punctuation.html
        # http://www.htmlescape.net/unicode_chart_miscellaneous_symbols.html
        element.instance_variable_set(:@statement,element.statement.gsub(/\u2013/,%q{-})) # &#8211;
        element.instance_variable_set(:@statement,element.statement.gsub(/\u2019/,%q{'})) # &#8217;
        element.instance_variable_set(:@statement,element.statement.gsub(/\u2020/,%q{"})) # &#8220;
        element.instance_variable_set(:@statement,element.statement.gsub(/\u2021/,%q{"})) # &#8221;
        element.instance_variable_set(:@statement,element.statement.gsub(/\u2605/,%q{*})) # &#9733;
      end

      # Math.xml contains a lot of unnecessarily escaped tags.
      def correct_unncessarily_escaped_html_tags(element)
        statement = element.statement
        [:sup, :i].each do |tag|
          statement.gsub!(/&lt;#{tag}&gt;/,%Q{<#{tag}>})
          statement.gsub!(/&lt;\/#{tag}&gt;/,%Q{</#{tag}>})
        end
        element.instance_variable_set(:@statement,statement)
      end

      # One ELA standard has it's own RefID (currently 32D9C8830A6C4fd5B715A1DFFC4D4BA4) set as it's code.
      def correct_literacy_rh_11_12_1_code(element)
        if (element.ref_id == '32D9C8830A6C4fd5B715A1DFFC4D4BA4' or element.parent_ref_id == 'F9877ECD38D8432185F96C5EC5A050AF') and element.statement.match('^Cite specific textual evidence')
          element.instance_variable_set(:@code,'CCSS.ELA-Literacy.RH.11-12.1')
        end
      end

      # Many standards contain html tags that are closed at the beginning of the following standard.
      def correct_unclosed_html_tags(element)
        [:i, :sup].each do |tag|
          strip_stray_close_tags(element,tag)
          append_missing_close_tags(element,tag)
        end
      end







      ######################################################################################

      def strip_stray_close_tags(element,tag)
        if starts_with_close?(element,tag)
          element.instance_variable_set(:@statement,element.statement.sub(/^<\/#{tag}>/,''))
        end
      end

      def append_missing_close_tags(element,tag)
        if more_opens_than_closes?(element,tag)
          element.instance_variable_set(:@statement,"#{element.statement}</#{tag}>")
        end
      end

      def starts_with_close?(element,tag)
        element.statement.match(/^<\/#{tag}>/)
      end


      def more_opens_than_closes?(element,tag)
        opens = element.statement.match(/<#{tag}>/)
        closes = element.statement.match(/<\/#{tag}>/)
        return false if opens.nil?
        return true if closes.nil? or (opens.size == closes.size + 1)
        raise "too many unclosed open <#{tag}> tags to deal with" if opens.size > closes.size + 1 # just in case this becomes an issue in the future so it can be identified immediately
        return false
      end
    end

  end
end