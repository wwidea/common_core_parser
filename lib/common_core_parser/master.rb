module CommonCoreParser
  class Master
    include Singleton

    ELEMENT_NAMES = [:elements, :domains, :clusters, :standards, :components, :subject_grades, :standard_types]
    attr_reader *( ELEMENT_NAMES.map { |element_name| "#{element_name}_hash" } )

    def initialize
      ELEMENT_NAMES.each do |element_name|
        instance_variable_set("@#{element_name}_hash",{})
      end
    end

    def load_math
      load_elements_from_paths(DATA_PATH+'/Math.xml',DATA_PATH+'/Mathematics/**/*.xml')
    end

    def load_ela
      load_elements_from_paths(DATA_PATH+'/ELA-Literacy.xml',DATA_PATH+'/ELA/**/*.xml')
    end

    def load_elements_from_paths(*paths)
      self.send(:initialize)
      paths.flatten.each do |path|
        Dir.glob(path).map do |filename|
          xml = Nokogiri::XML(File.open(filename))
          xml.xpath('//LearningStandardItem').each do |learning_standard_item|
            klass = get_class_from_element(learning_standard_item)
            add_element(klass.new(learning_standard_item))
          end
        end
      end
      correct_bad_data
      reunite_children_with_parents
      return standards
    end

    def add_element(element)
      return if element.illigit?
      raise "#{element} has same ref_id as #{@elements_hash[element.ref_id]}" if @elements_hash[element.ref_id]
      @elements_hash[element.ref_id] = element
      instance_variable_get(instance_variable_name_for_element(element))[element.ref_id] = element
    end

    def delete_element(element)
      @elements_hash.delete(element.classified_ref_id)
      instance_variable_get(instance_variable_name_for_element(element)).delete(element.ref_id)
    end

    # Create methods for each element type that returns
    # and array of elements instead of a hash
    ELEMENT_NAMES.each do |element_name|
      define_method(element_name) do
        instance_variable_get(instance_variable_name_for_element_name(element_name)).values
      end
    end

    #######
    private
    #######

    def correct_bad_data
      BrokenDataCorrector.run
    end

    def reunite_children_with_parents
      elements.each do |element|
        elements_hash[element.parent_ref_id].add_child(element) unless elements_hash[element.parent_ref_id].nil?
      end
    end

    def get_class_from_element(xml_element)
      hierarcy_level_description = xml_element.xpath('./StandardHierarchyLevel/description').first || xml_element.xpath('./StandardHierarchyLevel/Description').first
      return "CommonCoreParser::#{hierarcy_level_description.text}".gsub(/\s/,'').constantize
    end

    def instance_variable_name_for_element(element)
      instance_variable_name_for_element_name(element.class.name.sub(/^.*::/, '').underscore.pluralize)
    end

    def instance_variable_name_for_element_name(element_name)
      "@#{element_name}_hash"
    end
  end
end