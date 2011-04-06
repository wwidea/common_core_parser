#!/usr/bin/env ruby
# encoding: UTF-8

require File.expand_path('../../init', __FILE__ )

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end
