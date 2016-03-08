require "minitest/autorun"
require "minitest/pride"
require_relative '../lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test
  def test_find_by_name_returns_nil_if_name_is_not_a_district
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
              :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_I => "./data/Title I students.csv"
                              } })

          ep = epr.find_by_name("cant_find")

    assert_equal nil, ep
  end

  def test_district_groups_returns_all_181_districts
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
                              } })

    assert_equal 181, epr.district_groups.count
  end

  def test_median_household_income_something
    skip
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
              :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_I => "./data/Title I students.csv"
                              } })

          ep = epr.create_hash_of_repo_data

    assert_equal "ACADEMY 20", ep.name
  end

  def test_string_range_int_converts_string_range_into_a_paired_array_of_integers
    skip
    epr = EconomicProfileRepository.new

    assert_equal [2005, 2009], epr.string_range_into_int("2005-2009")
  end

  def test_match_timeframe_to_data_creates_hash_of_time_frame_to_data
    skip
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
    skip
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
    skip
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
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
              :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_I => "./data/Title I students.csv"
                              } })

    ep = epr.find_by_name("ACADEMY 20")

    assert_equal 85060, ep.median_household_income_in_year(2005)
  end

  def test_match_timeframe_to_percent_creates_a_hash_of_timefram_to_percent
    skip
    epr = EconomicProfileRepository.new

    input = [ {:timeframe=>"2005", :data=>"0.123"},
              {:timeframe=>"2006", :data=>"0.234"},
              {:timeframe=>"2008", :data=>"0.456"} ]

    output = { 2005 => 0.123, 2006 => 0.234, 2008 => 0.456 }

    assert_equal output, epr.match_timeframe_to_percent(input)
  end

  def test_hash_repo_creates_a_hash_by_district_of_repo_data
    skip
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
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
              :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_I => "./data/Title I students.csv"
                              } })

    ep = epr.find_by_name("ACADEMY 20")

    assert_equal 0.033, ep.children_in_poverty_in_year(2002)
    assert_equal 0.011, ep.title_I_in_year(2011)
  end

  def test_hash_repo_for_free_or_reduced_price_lunch_creates_hash_from_loaded_data
    epr = EconomicProfileRepository.new
    epr.load_data({
          :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
              :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_I => "./data/Title I students.csv"
                              } })
    repo = epr.free_or_reduced_price_lunch
    epr.hash_repo_for_free_or_reduced_price_lunch(repo)

  end

  # def test_adjust_string_data_converts_

end
