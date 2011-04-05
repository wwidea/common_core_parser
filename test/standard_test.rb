require 'test_helper'

class StandardTest < Test::Unit::TestCase
  
  test "gotta start somewhere" do
    assert true
  end
  
private
  
  def math_standard
    @math_standard ||= File.expand_path()
  end
end
