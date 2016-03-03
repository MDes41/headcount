require_relative "minitest/autorun"
require_relative "minitest/pride"
require_relative "./lib/enrollment_repository"

class EnrollmentRepositoryTest < Minitest::Test

  def test_that_find_by_name_returns_nil_if_name_not_found
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
                      }
                })
    enrollment = er.find_by_name("cant find me")
    assert_equal nil, enrollment
  end

  def test_that_find_by_name_returns_enrollment_instance_from_name
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
                      }
                })
    enrollment = er.find_by_name("ACADEMY 20")
    output = Enrollment.new({name: "ACADEMY 20"})
    assert_equal output.name, enrollment.name
  end

  def test_that_kindergarten_participation_groups_by_district_name
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
                      }
                })

    assert_equal "Colorado", er.enrollment_instances.first.name

  end

  def test_kindergarten_participation_by_year_returns_a_hash_with_years_as_keys_and_a_truncated_three_digit_floating_point_number
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
                      }
                })
    enrollment = er.find_by_name("ACADEMY 20")
    output = {  "2007"=>"0.391",
                "2006"=>"0.353",
                "2005"=>"0.267",
                "2004"=>"0.302",
                "2008"=>"0.384",
                "2009"=>"0.390",
                "2010"=>"0.436",
                "2011"=>"0.489",
                "2012"=>"0.478",
                "2013"=>"0.487",
                "2014"=>"0.490"
              }

    assert_equal output, enrollment.kindergarten_participation_by_year
  end

  def test_that_kindergarten_participation_in_year_returns_three_digit_truncated_floating_point_number_representing_a_percentage
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
                      }
                })
    enrollment = er.find_by_name("ACADEMY 20")
    output = "0.436"

    assert_equal output, enrollment.kindergarten_participation_in_year(2010)
  end

  def test_that_kindergarten_participation_in_year_returns_nil_if_year_is_not_included
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
                      }
                })
    enrollment = er.find_by_name("ACADEMY 20")
    output = nil

    assert_equal output, enrollment.kindergarten_participation_in_year(2020)
  end
end
