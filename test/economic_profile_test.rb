require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/economic_profile'

class EconomicProfileTest < Minitest::Test
  def test_that_economic_profile_class_creates_a_district_with_a_name
    ep = EconomicProfile.new(name: "ACADEMY 20")

    assert_equal "ACADEMY 20", ep.name
  end

  def test_median_household_income_with_keys_as_range_converts_keys_of_data_input_into_a_range
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000}}

    economic_profile = EconomicProfile.new(data)

    output = [2005, 2006, 2007, 2008, 2009]
    assert_equal output, economic_profile.median_household_incomes_with_keys_as_range.keys.first
  end

  def test_incomes_for_year_with_year_returns_incomes_in_an_array_if_year_is_in_range
    data = {:median_household_income => { [2005, 2009] => 50000,
                                          [2005, 2014] => 60000,
                                          [2010, 2014] => 70000 }}

    economic_profile = EconomicProfile.new(data)

    output = [60000, 70000]
    assert_equal output, economic_profile.incomes_for_year(2010)
  end

  def test_median_household_income_in_year_takes_in_structured_data_and_returns_unkowndataerror_if_not_in_data_set
    skip
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000}}

    economic_profile = EconomicProfile.new(data)

    assert_equal "UnknownDataError", economic_profile.median_household_income_in_year(2004)
  end

  def test_median_household_income_in_year_takes_in_structured_data_and_returns_correct_integer
    data = {:median_household_income => { [2005, 2009] => 50000,
                                          [2006, 2014] => 60000 }}

    economic_profile = EconomicProfile.new(data)

    assert_equal 50000, economic_profile.median_household_income_in_year(2005)
    assert_equal 55000, economic_profile.median_household_income_in_year(2007)
  end
  #
  # data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
  #         :children_in_poverty => {2012 => 0.1845},
  #         :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
  #         :title_i => {2015 => 0.543},
  #         :name => "ACADEMY 20"
  #         }
  # economic_profile = EconomicProfile.new(data)
  #
  # assert_equal "UnknownDataError", economic_profile.median_household_income_in_year(2004)



end
