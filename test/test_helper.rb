#!/usr/bin/env ruby
# encoding: UTF-8

require File.expand_path('../../init', __FILE__)
require 'test/unit'

class ::Test::Unit::TestCase
  class << self
    # test "verify something" do
    #   ...
    # end
    def test(name, &block)
      test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
      defined = instance_method(test_name) rescue false
      raise "#{test_name} is already defined in #{self}" if defined
      if block_given?
        define_method(test_name, &block)
      else
        define_method(test_name) do
          flunk "No implementation provided for #{name}"
        end
      end
    end
  end
end
