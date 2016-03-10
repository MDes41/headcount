require_relative 'test_helper'
require "minitest/autorun"
require "minitest/pride"
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
require_relative '../lib/statewide_test'
require_relative '../lib/errors'
require 'pry'


class HeadcountAnalystTest < Minitest::Test

  def test_average_districts_participation_for_one_district_is_calculated_correctly
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv",
  :high_school_graduation => "./data/High school graduation rates.csv"
                    }
              })
    ha = HeadcountAnalyst.new(dr)
    evaluate = ha.average_of_districts_participation("Academy 20")

    assert_equal 0.4061, evaluate.round(4)
  end

  def test_kindergarten_participation_rate_variation_gets_the_correct_value
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv",
  :high_school_graduation => "./data/High school graduation rates.csv"
                    }
              })
    ha = HeadcountAnalyst.new(dr)
    evaluate = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal 0.766, evaluate
  end

  def test_kindergarten_participation_rate_variation_against_another_district_gets_the_correct_value
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv",
  :high_school_graduation => "./data/High school graduation rates.csv"
                    }
              })
    ha = HeadcountAnalyst.new(dr)
    evaluate = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')

    assert_equal 0.447, evaluate
  end

  def test_kindergarten_participation_rate_variation_trend_calculates_trending_participation_rates
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv",
  :high_school_graduation => "./data/High school graduation rates.csv"
                    }
              })
    ha = HeadcountAnalyst.new(dr)
  evaluate = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')

    output = {2007=>0.992,
              2006=>1.051,
              2005=>0.96,
              2004=>1.258,
              2008=>0.718,
              2009=>0.652,
              2010=>0.681,
              2011=>0.728,
              2012=>0.688,
              2013=>0.694,
              2014=>0.661}

    assert_equal output, evaluate
  end

  def test_kindergarten_participation_rate_variation_trend_output_is_a_hash
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv",
  :high_school_graduation => "./data/High school graduation rates.csv"
                    }
              })
    ha = HeadcountAnalyst.new(dr)
    evaluate = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')

    output = Hash

    assert_equal output, evaluate.class
  end

  def test_that_kindergarten_participation_correlates_with_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv",
  :high_school_graduation => "./data/High school graduation rates.csv"
                    }
              })
    ha = HeadcountAnalyst.new(dr)
    evaluate = ha.kindergarten_participation_correlates_with_high_school_graduation(for: "ACADEMY 20")

    output = true

    assert_equal output, evaluate
  end

  def test_high_school_graduation_rate_variation_against_another_district_gets_the_correct_value
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv",
  :high_school_graduation => "./data/High school graduation rates.csv"
                    }
              })
    ha = HeadcountAnalyst.new(dr)
    evaluate = ha.hs_graduation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')

    assert_equal 1.011, evaluate
  end

  def test_that_kindergarten_participation_against_high_school_graduation_works_statewide
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv",
  :high_school_graduation => "./data/High school graduation rates.csv"
                    }
              })
    ha = HeadcountAnalyst.new(dr)
    evaluate = ha.kindergarten_participation_correlates_with_high_school_graduation(for: "STATEWIDE")

    output = false

    assert_equal output, evaluate
  end

  def test_that_kindergarten_participation_against_high_school_graduation_works_across_multiple_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv",
  :high_school_graduation => "./data/High school graduation rates.csv"
                    }
              })
    ha = HeadcountAnalyst.new(dr)
    districts = { across: ['ACADEMY 20', 'ADAMS COUNTY 14', 'ADAMS-ARAPAHOE 28J', 'AGATE 300' ]}

    evaluate = ha.kindergarten_participation_correlates_with_high_school_graduation(districts)

    output = false

    assert_equal output, evaluate
  end

  def test_percentage_growth_for_district_calculates_the_correct_percentage_growth_across_three_methods
    ha = HeadcountAnalyst.new
    input3 = {:proficiency_by_year_3g =>
              {2008=>{:math=>0.4, :reading=>0.4, :writing=>"N/A"},
               2009=>{:math=>0.8, :reading=>"N/A", :writing=>0.536},
               2010=>{:math=>"N/A",   :reading=>0.8, :writing=>0.504}}}
    input8 = {:proficiency_by_year_8g =>
               {2008=>{:math=>0.697, :reading=>0.4, :writing=>"N/A"},
                2009=>{:math=>0.691, :reading=>"N/A", :writing=>0.4},
                2010=>{:math=>"N/A", :reading=>0.8, :writing=>0.8}}}

    st3 = StatewideTest.new(input3)
    st8 = StatewideTest.new(input8)
    assert_equal 0.4, ha.percentage_growth_for_district(st3, :math, 3)
    assert_equal 0.2, ha.percentage_growth_for_district(st3, :reading, 3)
    assert_equal 0.4, ha.percentage_growth_for_district(st8, :writing, 8)
    assert_equal 0.2, ha.percentage_growth_for_district(st8, :reading, 8)
  end

  def test_proficiency_accross_valid_years_finds_the_proficiencies_in_subject_and_year_range
    ha = HeadcountAnalyst.new
    input = {:proficiency_by_year_3g =>
              {2008=>{:math=>0.697, :reading=>0.703, :writing=>"N/A"},
               2009=>{:math=>0.691, :reading=>"N/A", :writing=>0.536},
               2010=>{:math=>"N/A",   :reading=>0.726, :writing=>0.504}}}

    st = StatewideTest.new(input)
    result = ha.proficiency_accross_valid_years(st, :math, 3, [2008, 2009])
    assert_equal [0.697, 0.691], result
  end

  def test_find_valid_years_across_district_takes_proficiency_data_and_only_takes_years_with_valid_years
    ha = HeadcountAnalyst.new
    input = {:proficiency_by_year_3g =>
              {2008=>{:math=>0.697, :reading=>0.703, :writing=>"N/A"},
               2009=>{:math=>0.691, :reading=>"N/A", :writing=>0.536},
               2010=>{:math=>"N/A",   :reading=>0.726, :writing=>0.504}}}

    st = StatewideTest.new(input)

    result = ha.find_valid_years_across_district(st, :math, 3)
    assert_equal [2008, 2009], result
    result2 = ha.find_valid_years_across_district(st, :reading, 3)
    assert_equal [2008, 2010], result2
    result3 = ha.find_valid_years_across_district(st, :writing, 3)
    assert_equal [2009, 2010], result3
  end

  def test_average_percentage_growth_accross_years_returns_average_of_proficiency_accross_years
    ha = HeadcountAnalyst.new
    years = [2005, 2007]
    proficiency = [0.3, 0.9]
    result = ha.average_percentage_growth_accross_years(years, proficiency)
    assert_equal 0.3, result
  end

  def test_top_statewide_test_year_over_year_growth_returns_insufficient_information_if_a_valid_argument_is_not_called
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
     },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    # result = ha.top_statewide_test_year_over_year_growth(subject: :math)
    assert_raises(InsufficientInformationError) { ha.top_statewide_test_year_over_year_growth(subject: :math) }

  end

  def test_top_statewide_test_year_over_year_growth_returns_valid_results_for_data_loaded_with_different_arguments
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
     },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    district = dr.find_by_name("WILEY RE-13 JT")
    result = ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    assert_equal ["WILEY RE-13 JT", 0.3], result
    result1 = ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
    assert_equal [["WILEY RE-13 JT", 0.3], ["SANGRE DE CRISTO RE-22J", 0.071], ["COTOPAXI RE-3", 0.07]], result1
    result3 = ha.top_statewide_test_year_over_year_growth(grade: 3)
    assert_equal ["SANGRE DE CRISTO RE-22J", 0.07], result3
    result4 = ha.top_statewide_test_year_over_year_growth(grade: 3, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
    assert_equal ["WILEY RE-13 JT", 0.118], result4
  end





end
