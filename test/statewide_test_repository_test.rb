require "minitest/autorun"
require "minitest/pride"
require 'pry'
require_relative "../lib/statewide_test_repository"
require_relative "../lib/statewide_test"


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

    output = {"2008"=>{"Math"=>0.64, "Reading"=>0.843, "Writing"=>0.734},
              "2009"=>{"Math"=>0.656, "Reading"=>0.825, "Writing"=>0.701},
              "2010"=>{"Math"=>0.672, "Reading"=>0.863, "Writing"=>0.754},
              "2011"=>{"Reading"=>0.832, "Math"=>0.653, "Writing"=>0.745},
              "2012"=>{"Math"=>0.681, "Writing"=>0.738, "Reading"=>0.833},
              "2013"=>{"Math"=>0.661, "Reading"=>0.852, "Writing"=>0.75},
              "2014"=>{"Math"=>0.684, "Reading"=>0.827, "Writing"=>0.747} }

    assert_equal output, statewide_test.proficient_by_grade(3)

  end






end
