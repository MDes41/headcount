require "minitest/autorun"
require "minitest/pride"
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
require 'pry'


class HeadcountAnalystTest < Minitest::Test

  def test_average_participation_for_one_district_is_calculated_correctly
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                  }
                })
    ha = HeadcountAnalyst.new(dr)
    evaluate = ha.average_district_kindergarten_participation_across_all_years("Academy 20")

    assert_equal 0.4061, evaluate.round(4)
  end

  def test_state_average_participation_for_one_district_is_calculated_correctly
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                  }
                })
    ha = HeadcountAnalyst.new(dr)
    evaluate = ha.state_average_kindergarten_participation_across_all_years(:against => 'COLORADO')

    assert_equal 0.5301, evaluate.round(4)
  end

  def test_kindergarten_participation_rate_variation_gets_the_correct_value
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
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
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                  }
                })
    ha = HeadcountAnalyst.new(dr)
    evaluate = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')

    assert_equal 0.766, evaluate
  end
end
