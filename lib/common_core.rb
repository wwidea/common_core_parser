#!/usr/bin/env ruby
# encoding: UTF-8

require 'rubygems'
require 'bundler/setup'
require 'nokogiri'

require File.expand_path('../common_core', __FILE__)
require File.expand_path('../common_core/element',  __FILE__)
require File.expand_path('../common_core/standard',  __FILE__)
require File.expand_path('../common_core/domain',  __FILE__)
require File.expand_path('../common_core/loader',  __FILE__)

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end
