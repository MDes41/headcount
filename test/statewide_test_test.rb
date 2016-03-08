require "minitest/autorun"
require "minitest/pride"
require 'pry'
require_relative "../lib/statewide_test"

class StatewideTestTest < MiniTest::Test

  def test_statewidetest_creates_an_object_with_a_name
    st = StatewideTest.new( { :name => "ACADEMY 20" } )
    assert_equal "ACADEMY 20", st.name
  end

  def test_proficient_for_subject_by_grade_in_year_returns_a_hash_grouped_by_race_referencing_percentages
    input = { :name=>"ACADEMY 20",
              :proficiency_by_race_or_ethnicity=>
                  {:asian=>
                      {2012=>{:math=>0.818, :reading=>0.893, :writing=>0.808}}}}

    statewide_test = StatewideTest.new(input)

    output = 0.818

    assert_equal output, statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
  end


end
