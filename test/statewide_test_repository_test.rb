require "minitest/autorun"
require "minitest/pride"
require 'pry'
require_relative "../lib/statewide_test_repository"
require_relative "../lib/statewide_test"
require 'simplecov'
SimpleCov.start


class StatewideTestRespositoryTest < Minitest::Test

  def test_find_by_name_finds_nil_if_name_is_not_a_district
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
              :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
             :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                     :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                  :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                  :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                            }
                  })
    str = str.find_by_name("cant_find")
    output = nil

    assert_equal output, str
  end

  def test_find_by_name_finds_the_district_from_the_data_loaded
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
              :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
             :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                     :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                  :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                  :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                            }
                  })
    str = str.find_by_name("ACADEMY 20")

    assert_equal 'ACADEMY 20', str.name
  end

  def test_proficient_by_grade_creates_instances_of_proficiency_and_that_you_can_find_it_with_method
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
              :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
             :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                     :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                  :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                  :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                            }
                  })
    statewide_test = str.find_by_name("ACADEMY 20")

    output = {2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671},
              2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
              2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
              2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
              2012=>{:reading=>0.87, :math=>0.83, :writing=>0.655},
              2013=>{:math=>0.855, :reading=>0.859, :writing=>0.668},
              2014=>{:math=>0.834, :reading=>0.831, :writing=>0.639}}

    assert_equal output, statewide_test.proficient_by_grade(3)

  end

  def test_proficient_by_race_or_ethnicity_returns_a_hash_grouped_by_racereferencing_percentages_by_subject
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
              :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
             :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                     :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                  :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                  :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                            }
                  })
    statewide_test = str.find_by_name("ACADEMY 20")

    output = {2011=>{:math=>0.816, :reading=>0.897, :writing=>0.826},
              2012=>{:math=>0.818, :reading=>0.893, :writing=>0.808},
              2013=>{:math=>0.805, :reading=>0.901, :writing=>0.81},
              2014=>{:math=>0.8,   :reading=>0.855, :writing=>0.789}}

    assert_equal output, statewide_test.proficient_by_race_or_ethnicity(:asian)
  end

  def test_proficient_for_subject_by_grade_in_year_returns_a_hash_grouped_by_race_referencing_percentages
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
              :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
             :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                     :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                  :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                  :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                            }
                  })
    statewide_test = str.find_by_name("ACADEMY 20")

    output = 0.857

    assert_equal output, statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end





end
