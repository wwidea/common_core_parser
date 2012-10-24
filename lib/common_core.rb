#!/usr/bin/env ruby
# encoding: UTF-8

require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'singleton'
require 'active_support/core_ext'

require File.expand_path('../common_core', __FILE__)
require File.expand_path('../common_core/master',  __FILE__)
require File.expand_path('../common_core/broken_data_corrector',  __FILE__)

require File.expand_path('../common_core/element',  __FILE__)
require File.expand_path('../common_core/elements/component',  __FILE__)
require File.expand_path('../common_core/elements/standard',  __FILE__)
require File.expand_path('../common_core/elements/cluster',  __FILE__)
require File.expand_path('../common_core/elements/domain',  __FILE__)
require File.expand_path('../common_core/elements/subject_grade',  __FILE__)
require File.expand_path('../common_core/elements/standard_type',  __FILE__)

module CommonCore
  DATA_PATH = File.expand_path('../../data', __FILE__)
end

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end
