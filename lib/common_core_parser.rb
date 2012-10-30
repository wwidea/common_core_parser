#!/usr/bin/env ruby
# encoding: UTF-8

require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'singleton'
require 'active_support/core_ext'

require File.expand_path('../common_core_parser', __FILE__)
require File.expand_path('../common_core_parser/master',  __FILE__)
require File.expand_path('../common_core_parser/broken_data_corrector',  __FILE__)

require File.expand_path('../common_core_parser/element',  __FILE__)
require File.expand_path('../common_core_parser/elements/component',  __FILE__)
require File.expand_path('../common_core_parser/elements/standard',  __FILE__)
require File.expand_path('../common_core_parser/elements/cluster',  __FILE__)
require File.expand_path('../common_core_parser/elements/domain',  __FILE__)
require File.expand_path('../common_core_parser/elements/subject_grade',  __FILE__)
require File.expand_path('../common_core_parser/elements/standard_type',  __FILE__)

module CommonCoreParser
  DATA_PATH = File.expand_path('../../data', __FILE__)
end

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end
