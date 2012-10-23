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

    def add_element(element)
      @elements[element.ref_id] = element
      instance_variable_name = "@#{element.class.name.sub(/^.*::/, '').underscore.pluralize}"
      instance_variable_get(instance_variable_name)[element.ref_id] = element
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
    end

    #######
    private
    #######

    def get_class_from_element(xml_element)
      hierarcy_level_description = xml_element.xpath('./StandardHierarchyLevel/description').first || xml_element.xpath('./StandardHierarchyLevel/Description').first
      return "CommonCore::#{hierarcy_level_description.text}".gsub(/\s/,'').constantize
    end
  end
end