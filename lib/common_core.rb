#!/usr/bin/env ruby
# encoding: UTF-8

require File.expand_path('../../init', __FILE__ )
require 'nokogiri'

standard = Nokogiri::XML(Pathname.new(File.expand_path('../../data/Mathematics/StandardItems/Grade1/10_can_be_thought_of_as_a_bundle_of_ten_ones.xml',  __FILE__)))
puts CommonCore::Standard.new(standard)

Dir.glob(File.expand_path('../../data/Mathematics/StandardItems/Grade*/*.xml',  __FILE__)).each do |filename|
  puts filename
  
  puts CommonCore::Standard.new(Nokogiri::XML(Pathname.new filename))
  puts ''
end
