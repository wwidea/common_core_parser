#!/usr/bin/env ruby
# encoding: UTF-8

require 'simplecov'
SimpleCov.start

require File.expand_path('../../lib/common_core', __FILE__)
require 'active_support'
require 'active_support/test_case'
require 'test/unit'

class ActiveSupport::TestCase
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
