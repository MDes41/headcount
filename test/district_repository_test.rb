require "minitest/autorun"
require "minitest/pride"
require 'pry'
require_relative "../lib/district_repository"
require_relative "../lib/district"


class DistrictRepositoryTest < Minitest::Test

  def test_cant_find_distrct_when_there_are_none
    dr = DistrictRepository.new

    result = dr.find_by_name("Hogwarts")

    assert_equal nil, result
  end

  def test_can_find_by_name
    district= District.new({name: "Turing"})
    dr = DistrictRepository.new([district])

    result = dr.find_by_name("Turing")
    assert_equal district, result
  end

  def test_can_find_multiple_matches
    district_1 = District.new({name: "Turing"})
    district_2 = District.new({name: "Turong"})
    district_3 = District.new({name: "Place"})

    dr = DistrictRepository.new([district_1, district_2, district_3])

        result = dr.find_all_matching("Tur")

        expected = [district_1, district_2]

        assert_equal expected, result
  end
end
