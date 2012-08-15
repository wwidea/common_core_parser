#!/usr/bin/env ruby
# encoding: UTF-8

module CommonCore
  class Loader
    class << self
      def math_standards
        load_elements_from_paths(CommonCore::Standard, File.expand_path('../../../data/Mathematics/StandardItems/Grade*/*.xml',  __FILE__))
      end
      
      def math_domains
        load_elements_from_paths(CommonCore::Domain, File.expand_path('../../../data/Mathematics/Standards/*.xml',  __FILE__))
      end
      
      def ela_standards
        load_elements_from_paths(CommonCore::Standard,
          File.expand_path('../../../data/ELA/Standard/*.xml',  __FILE__),
        )
      end
      
      def ela_domains
        load_elements_from_paths(CommonCore::Domain, File.expand_path('../../../data/ELA/Domain/*.xml',  __FILE__))
      end
      
    private
      
      def load_elements_from_paths(klass, *paths)
        Array.new.tap do |elements|
          paths.flatten.each do |path|
            Dir.glob(path).map do |filename|
              begin
                elements << klass.new(Nokogiri::XML(Pathname.new filename))
              rescue
                nil
              end
            end
          end
        end
      end
    end
  end
end
