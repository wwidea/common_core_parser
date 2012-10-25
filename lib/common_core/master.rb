module CommonCore
  class Master
    include Singleton

    attr_reader :elements, :domains, :clusters, :standards, :components, :subject_grades, :standard_types

    def initialize
      @elements = {}
      @domains = {}
      @clusters = {}
      @standards = {}
      @components = {}
      @subject_grades = {}
      @standard_types = {}
    end

    def load_elements_from_paths(*paths)
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
    end

    def add_element(element)
      return if element.illigit?
      puts "#{element} has same ref_id as #{@elements[element.ref_id]}" if @elements[element.ref_id]
      @elements[element.ref_id] = element
      instance_variable_name = "@#{element.class.name.sub(/^.*::/, '').underscore.pluralize}"
      instance_variable_get(instance_variable_name)[element.ref_id] = element
    end

    def delete_element(element)
      @elements.delete(element.classified_ref_id)
      instance_variable_name = "@#{element.class.name.sub(/^.*::/, '').underscore.pluralize}"
      instance_variable_get(instance_variable_name).delete(element.ref_id)
    end

    #######
    private
    #######

    def correct_bad_data
      BrokenDataCorrector.run
    end

    def reunite_children_with_parents
      elements.each_pair do |ref_id,element|
        elements[element.parent_ref_id].add_child(element) unless elements[element.parent_ref_id].nil?
      end
    end

    def get_class_from_element(xml_element)
      hierarcy_level_description = xml_element.xpath('./StandardHierarchyLevel/description').first || xml_element.xpath('./StandardHierarchyLevel/Description').first
      return "CommonCore::#{hierarcy_level_description.text}".gsub(/\s/,'').constantize
    end
  end
end