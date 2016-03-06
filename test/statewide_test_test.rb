require "minitest/autorun"
require "minitest/pride"
require 'pry'
require_relative "../lib/statewide_test"

class StatewideTestTest < MiniTest::Test

  def test_statewidetest_creates_an_object_with_a_name
    st = StatewideTest.new( { :name => "ACADEMY 20" } )
    assert_equal "ACADEMY 20", st.name
  end

  

end
