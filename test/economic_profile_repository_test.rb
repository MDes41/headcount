require "minitest/autorun"
require "minitest/pride"
require_relative '../lib/economic_profile_repository'
require_relative 'test_helper'

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

  def test_string_range_int_converts_string_range_into_a_paired_array_of_integers
    epr = EconomicProfileRepository.new

    assert_equal [2005, 2009], epr.string_range_into_int("2005-2009")
  end

  def test_match_timeframe_to_data_creates_hash_of_time_frame_to_data
    epr = EconomicProfileRepository.new

    input = [ {:timeframe=>"2005-2009", :data=>"56222"},
              {:timeframe=>"2006-2010", :data=>"56456"},
              {:timeframe=>"2008-2012", :data=>"58244"} ]

    epr.match_timeframe_to_data_range(input)

    output =     { [2005, 2009] => 56222,
                   [2006, 2010] => 56456,
                   [2008, 2012] => 58244 }

    assert_equal output, epr.match_timeframe_to_data_range(input)
  end

  def test_group_by_location_groups_districts_to_repo_data
    epr = EconomicProfileRepository.new

    input = [{:location=>"Colorado", :district_data=>'data'},
             {:location=>"ACADEMY 20", :district_data=>'data'},
             {:location=>"ACADEMY 20", :district_data=>'data'},
             {:location=>"ADAMS COUNTY 14", :district_data=>'data'},
             {:location=>"ADAMS COUNTY 14", :district_data=>'data'},
             {:location=>"ADAMS COUNTY 14", :district_data=>'data'}]

    output = [{:location=>"Colorado", :district_data=>'data'}]
    assert_equal 3, epr.group_by_location(input).keys.count
    assert_equal output, epr.group_by_location(input)["Colorado"]
  end

  def test_create_hash_of_repo_data_returns_a_hash_of_modified_district_repo_data
    epr = EconomicProfileRepository.new

    input = [{:location=>"Colorado", :timeframe=>"2005-2009", :data=>"56222"},
             {:location=>"ACADEMY 20", :timeframe=>"2005-2009", :data=>"85060"},
             {:location=>"ACADEMY 20", :timeframe=>"2006-2010", :data=>"85450"},
             {:location=>"ADAMS COUNTY 14", :timeframe=>"2005-2009", :data=>"41382"},
             {:location=>"ADAMS COUNTY 14", :timeframe=>"2006-2010", :data=>"40740"},
             {:location=>"ADAMS COUNTY 14", :timeframe=>"2008-2012", :data=>"41886"}]

    output = {      "Colorado" => { [2005, 2009] => 56222 },
                  "ACADEMY 20" => { [2005, 2009] => 85060,
                                    [2006, 2010] => 85450 },
             "ADAMS COUNTY 14" => { [2005, 2009] => 41382,
                                    [2006, 2010] => 40740,
                                    [2008, 2012] => 41886 }
                            }

    assert_equal output, epr.hash_repo_for_median_income(input)
  end

  def test_find_by_name_returns_nil_if_name_is_not_a_district
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
              :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_i => "./data/Title I students.csv"
                              } })

    ep = epr.find_by_name("ACADEMY 20")

    assert_equal 85060, ep.median_household_income_in_year(2005)
  end

  def test_match_timeframe_to_percent_creates_a_hash_of_timefram_to_percent
    epr = EconomicProfileRepository.new

    input = [ {:timeframe=>"2005", :data=>"0.123"},
              {:timeframe=>"2006", :data=>"0.234"},
              {:timeframe=>"2008", :data=>"0.456"} ]

    output = { 2005 => 0.123, 2006 => 0.234, 2008 => 0.456 }

    assert_equal output, epr.match_timeframe_to_percent(input)
  end

  def test_hash_repo_creates_a_hash_by_district_of_repo_data
    epr = EconomicProfileRepository.new

    input = [{:location=>"Colorado", :timeframe=>"2005", :data=>"0.123"},
             {:location=>"ACADEMY 20", :timeframe=>"2005", :data=>"0.123"},
             {:location=>"ACADEMY 20", :timeframe=>"2006", :data=>"0.123"},
             {:location=>"ADAMS COUNTY 14", :timeframe=>"2005", :data=>"0.123"},
             {:location=>"ADAMS COUNTY 14", :timeframe=>"2006", :data=>"0.123"},
             {:location=>"ADAMS COUNTY 14", :timeframe=>"2008", :data=>"0.123"}]

    output = {      "Colorado" => { 2005 => 0.123 },
                  "ACADEMY 20" => { 2005 => 0.123,
                                    2006 => 0.123 },
             "ADAMS COUNTY 14" => { 2005 => 0.123,
                                    2006 => 0.123,
                                    2008 => 0.123 }
                            }

    assert_equal output, epr.hash_percent_repo(input)
  end

  def test_children_in_poverty_and_title_I_data_is_attached_to_economic_profile_instance
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
              :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_i => "./data/Title I students.csv"
                              } })

    ep = epr.find_by_name("ACADEMY 20")

    assert_equal 0.033, ep.children_in_poverty_in_year(2002)
    assert_equal 0.011, ep.title_i_in_year(2011)
  end

  def test_adjust_string_data_takes_in_data_format_and_data_and_truncates_percentages_and_adjusts_strings_to_integers
    epr = EconomicProfileRepository.new

    assert_equal [ :percentage, 0.012 ], epr.adjust_string_data("Percent", "0.01234")
    assert_equal [ :total, 12345 ], epr.adjust_string_data('Number', "12345")
  end

  def test_group_poverty_level_creates_hash_of_number_and_percent_attached_to_year_of_only_eligible_for_reduce_price_lunch
    epr = EconomicProfileRepository.new

    input = [{:location=>"Colorado", :poverty_level=>"Eligible for Reduced Price Lunch", :timeframe=>"2000", :dataformat=>"Percent", :data=>"0.07"},
             {:location=>"Colorado", :poverty_level=>"Eligible for Free or Reduced Lunch", :timeframe=>"2000", :dataformat=>"Percent", :data=>"0.27"},
             {:location=>"Colorado", :poverty_level=>"Eligible for Free Lunch", :timeframe=>"2000", :dataformat=>"Percent", :data=>"0.2"},
             {:location=>"Colorado", :poverty_level=>"Eligible for Reduced Price Lunch", :timeframe=>"2000", :dataformat=>"Number", :data=>"50698"},
             {:location=>"Colorado", :poverty_level=>"Eligible for Free Lunch", :timeframe=>"2000", :dataformat=>"Number", :data=>"144451"},
             {:location=>"Colorado", :poverty_level=>"Eligible for Free or Reduced Lunch", :timeframe=>"2000", :dataformat=>"Number", :data=>"195149"}]

    assert_equal [ { 2000 => { :total => 195149, :percentage => 0.27 }} ], epr.group_by_poverty_level(input)
  end

  def test_hash_repo_for_free_or_reduced_lunch_hashes_district_to_year_to_percent_data
    epr = EconomicProfileRepository.new

    input = [{:location=>"Colorado", :poverty_level=>"Eligible for Reduced Price Lunch", :timeframe=>"2000", :dataformat=>"Percent", :data=>"0.07"},
             {:location=>"Colorado", :poverty_level=>"Eligible for Free or Reduced Lunch", :timeframe=>"2000", :dataformat=>"Percent", :data=>"0.27"},
             {:location=>"Colorado", :poverty_level=>"Eligible for Free Lunch", :timeframe=>"2000", :dataformat=>"Percent", :data=>"0.2"},
             {:location=>"Colorado", :poverty_level=>"Eligible for Reduced Price Lunch", :timeframe=>"2000", :dataformat=>"Number", :data=>"50698"},
             {:location=>"Colorado", :poverty_level=>"Eligible for Free Lunch", :timeframe=>"2000", :dataformat=>"Number", :data=>"144451"},
             {:location=>"Colorado", :poverty_level=>"Eligible for Free or Reduced Lunch", :timeframe=>"2000", :dataformat=>"Number", :data=>"195149"}]

    assert_equal ({ "Colorado" => { 2000 => { :total => 195149, :percentage => 0.27 }}}), epr.hash_repo_for_free_or_reduced_price_lunch(input)
  end

  def test_hash_repo_for_free_or_reduced_price_lunch_creates_hash_from_loaded_data
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
              :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_i => "./data/Title I students.csv"
                              } })
    repo = epr.free_or_reduced_price_lunch

    assert_equal ["Colorado" , { 2000 => { :total => 195149, :percentage => 0.27 }}], epr.hash_repo_for_free_or_reduced_price_lunch(repo).first
    assert_equal 181, epr.hash_repo_for_free_or_reduced_price_lunch(repo).keys.count
    assert_equal 181, epr.hash_repo_for_free_or_reduced_price_lunch(repo).values.count
  end

  def test_that_economic_profile_class_creates_a_district_with_a_name
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
              :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_i => "./data/Title I students.csv"
                              } })

    economic_profile = epr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", economic_profile.name
    assert_equal 85060, economic_profile.median_household_income_in_year(2005)
    assert_equal 87605, economic_profile.median_household_income_average
    assert_equal 0.064, economic_profile.children_in_poverty_in_year(2012)
    assert_equal 0.127, economic_profile.free_or_reduced_price_lunch_percentage_in_year(2014)
    assert_equal 3132, economic_profile.free_or_reduced_price_lunch_number_in_year(2014)
    assert_equal 0.027, economic_profile.title_i_in_year(2014)
  end





end
