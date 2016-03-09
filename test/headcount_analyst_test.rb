require_relative 'test_helper'
require "minitest/autorun"
require "minitest/pride"
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
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

    output = { 2007=>0.992,
               2006=>1.051,
               2005=>0.96,
               2004=>1.258,
               2008=>0.718,
               2009=>0.652,
               2010=>0.681,
               2011=>0.728,
               2012=>0.688,
               2013=>0.694,
               2014=>0.661 }



    assert_equal output, evaluate
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


end
