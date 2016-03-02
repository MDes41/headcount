require "minitest/autorun"
require "minitest/pride"
require 'pry'
require_relative "../lib/district_repository"
require_relative "../lib/district"


class DistrictRepositoryTest < Minitest::Test

  def test_find_by_name_finds_the_district_from_the_data_loaded
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                    }
                })

    district = dr.find_by_name("ACADEMY 20").name
    output = District.new({location: "ACADEMY 20"}).name

    assert_equal output, district
  end

  def test_find_by_name_finds_nil_if_name_is_not_a_district
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                    }
                })

    district = dr.find_by_name("cant find me")

    assert_equal nil, district
  end

  def test_find_all_matching_returns_empty_array_if_no_name_fragment_is_matched
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                    }
                })

    assert_equal [], dr.find_all_matching("cant find me")
  end

  def test_find_all_matching_returns_instances_of_matching_names
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                    }
                })

    assert_equal 11, dr.find_all_matching("Academy").count
  end

  
end
