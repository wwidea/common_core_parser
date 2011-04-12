#!/usr/bin/env ruby
# encoding: UTF-8

module CommonCore
  class Loader
    class << self
      def math_standards
        load_elements_from_path(CommonCore::Standard, File.expand_path('../../../data/Mathematics/StandardItems/Grade*/*.xml',  __FILE__))
      end
      
      def math_domains
        load_elements_from_path(CommonCore::Domain, File.expand_path('../../../data/Mathematics/Standards/*.xml',  __FILE__))
      end
      
      def ela_standards
        load_elements_from_path(CommonCore::Standard, File.expand_path('../../../data/ELA_08302010/StandardItems/Grade*/*.xml',  __FILE__))
      end
      
      def ela_domains
        load_elements_from_path(CommonCore::Domain, File.expand_path('../../../data/ELA_08302010/Standards/*.xml',  __FILE__))
      end
      
    private
      
      def load_elements_from_path(klass, path)
        (Dir.glob(path).map do |filename|
          klass.new(Nokogiri::XML(Pathname.new filename)) rescue nil
        end).compact
      end
    end
  end
end
