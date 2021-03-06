require_relative 'test_helper'
require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/district_repository"
require_relative "../lib/district"


class DistrictRepositoryTest < Minitest::Test


  def test_find_by_name_finds_the_district_from_the_data_loaded
    # skip
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
                      }
                })

    district = dr.find_by_name("ACADEMY 20").name
    output = District.new(name: "ACADEMY 20").name

    assert_equal output, district
  end

  def test_find_by_name_finds_nil_if_name_is_not_a_district
    # skip
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
                      }
                })

    district = dr.find_by_name("cant find me")

    assert_equal nil, district
  end


  def test_find_all_matching_returns_instances_of_matching_names
    # skip
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
                      }
                })

    assert_equal 1, dr.find_all_matching("Academy").count
  end

  def test_find_all_matching_returns_empty_array_if_no_name_fragment_is_matched
    # skip
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
                      }
                })

      assert_equal [], dr.find_all_matching("cant find me")
  end

  def test_district_repository_creates_enrollment_instances_on_district_instance
    # skip
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
                      }
                })

    district = dr.find_by_name("ACADEMY 20")
    # require "pry"; binding.pry
    result = district.enrollment.kindergarten_participation_in_year(2010)

    assert_equal 0.436, result
  end

  def test_distric_repository_creates_statewide_test_instances_on_district_object_when_data_is_loaded
    # skip
    dr = DistrictRepository.new

    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv",
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })

    district = dr.find_by_name("ACADEMY 20")
    result = district.statewide_test.proficient_for_subject_by_grade_in_year(:math, 8, 2014)

    assert_equal 0.684, result
  end

  def test_distric_repository_creates_statewide_test_instances_on_district_object_when_data_is_loaded
    dr = DistrictRepository.new

    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv",
      },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })

    district = dr.find_by_name("ACADEMY 20")
    result = district.economic_profile.median_household_income_in_year(2005)

    assert_equal 85060, result
  end

  def test_that_districts_are_grouped_in_statewide_repo
    dr = DistrictRepository.new

    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv",
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    result = dr.statewide_testing_by_district.keys.first

    assert_equal "Colorado", result
  end

end
