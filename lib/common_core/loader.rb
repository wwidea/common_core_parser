#!/usr/bin/env ruby
# encoding: UTF-8

module CommonCore
  class Loader
    class << self
      def math_standards
        Dir.glob(File.expand_path('../../../data/Mathematics/StandardItems/Grade*/*.xml',  __FILE__)).map do |filename|
          CommonCore::Standard.new(Nokogiri::XML(Pathname.new filename))
        end
      end
    end
  end
end
