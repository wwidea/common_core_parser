#!/usr/bin/env ruby
# encoding: UTF-8

module CommonCore
  class Loader
    class << self
      def math_standards
        load_standards_from_path File.expand_path('../../../data/Mathematics/StandardItems/Grade*/*.xml',  __FILE__)
      end
      
      def math_domains
        load_domains_from_path File.expand_path('../../../data/Mathematics/Standards/*.xml',  __FILE__)
      end
      
      def ela_standards
        load_standards_from_path File.expand_path('../../../data/ELA_08302010/StandardItems/Grade*/*.xml',  __FILE__)
      end
      
    private
      
      def load_standards_from_path(path)
        (Dir.glob(path).map do |filename|
          CommonCore::Standard.new(Nokogiri::XML(Pathname.new filename)) rescue nil
        end).compact
      end
      
      def load_domains_from_path(path)
        (Dir.glob(path).map do |filename|
          CommonCore::Domain.new(Nokogiri::XML(Pathname.new filename)) rescue nil
        end).compact
      end
    end
  end
end
