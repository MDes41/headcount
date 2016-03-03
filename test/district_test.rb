require_relative "minitest/autorun"
require_relative "./lib/district"

class DistrictTest <Minitest::Test

  def test_name_passed_to_district_class_it_has_a_name
    district = District.new("ACADEMY 20")

    assert_equal "ACADEMY 20", district.name
  end

end
