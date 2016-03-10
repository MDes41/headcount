require_relative "test_helper"
require_relative '../lib/errors'
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

  def test_unknown_data_error_is_raised_when_data_is_not_valid
    input = { :name=>"ACADEMY 20",
              :proficiency_by_race_or_ethnicity=>
                  {:asian=>
                      {2012=>{:math=>0.818, :reading=>0.893, :writing=>0.808}}}}

    statewide_test = StatewideTest.new(input)
    assert_raises(UnknownDataError) { statewide_test.proficient_by_grade(9) }
    assert_raises(UnknownDataError) { statewide_test.proficient_by_race_or_ethnicity(:unknown) }
    assert_raises(UnknownDataError) { statewide_test.proficient_for_subject_by_grade_in_year(:math, 9, 2014) }
    assert_raises(UnknownDataError) { statewide_test.proficient_for_subject_by_grade_in_year(:unknown, 8, 2014) }
    assert_raises(UnknownDataError) { statewide_test.proficient_for_subject_by_race_in_year(:unknown, :asian, 3) }
    assert_raises(UnknownDataError) { statewide_test.proficient_for_subject_by_race_in_year(:math, :unknown, 3) }

  end

  def test_that_proficient_by_grade_for_eighth_grade_gets_the_correct_data_when_loaded
    input = { :proficiency_by_year_8g =>
            {2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671},
            2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
            2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
            2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678}}}

    st = StatewideTest.new(input)

    output = {2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671},
              2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
              2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
              2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678}}

    assert_equal output, st.proficient_by_grade(8)
  end



end
