require "minitest/autorun"
require "./lib/district"

class DistrictTest <Minitest::Test

  def test_it_has_a_name
    district = District.new({:name => "ACADEMY 20"})

    assert_equal "ACADEMY 20", district.name
  end

  def test_it_returns_upcased_version
    district = District.new({:name => "academy 20"})
    assert_equal "academy 20", district.name
  end
end
