require "minitest/autorun"
require "minitest/pride"
require_relative '../lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test
  def test_find_by_name_returns_nil_if_name_is_not_a_district
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
              :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_i => "./data/Title I students.csv"
                              } })

          ep = epr.find_by_name("cant_find")

    assert_equal nil, ep
  end

  def test_district_groups_returns_all_181_districts
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
                              } })

    assert_equal 181, epr.district_groups.count
  end

  def test_find_by_name_finds_the_district_from_the_data_loaded
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
              :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_i => "./data/Title I students.csv"
                              } })

          ep = epr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", ep.name
  end

  
end
