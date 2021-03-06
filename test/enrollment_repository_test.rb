require_relative 'test_helper'
require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/enrollment_repository"

class EnrollmentRepositoryTest < Minitest::Test

  def test_that_find_by_name_returns_nil_if_name_not_found
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
                      }
                })
    enrollment = er.find_by_name("cant find me")
    assert_equal nil, enrollment
  end

  def test_that_find_by_name_returns_enrollment_instance_from_name
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
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
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
                      }
                })

    assert_equal "Colorado", er.enrollment_instances.first.name

  end

  def test_kindergarten_participation_by_year_returns_a_hash_with_years_as_keys_and_a_truncated_three_digit_floating_point_number
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
                      }
                })
    enrollment = er.find_by_name("ACADEMY 20")
    output = {  2007=>0.391,
                2006=>0.353,
                2005=>0.267,
                2004=>0.302,
                2008=>0.384,
                2009=>0.39,
                2010=>0.436,
                2011=>0.489,
                2012=>0.478,
                2013=>0.487,
                2014=>0.49
              }

    assert_equal output, enrollment.kindergarten_participation_by_year
  end

  def test_that_kindergarten_participation_in_year_returns_three_digit_truncated_floating_point_number_representing_a_percentage
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
                      }
                })
    enrollment = er.find_by_name("GUNNISON WATERSHED RE1J")
    output = 0.144

    assert_equal output, enrollment.kindergarten_participation_in_year(2004)
  end

  def test_that_kindergarten_participation_in_year_returns_nil_if_year_is_not_included
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
                      }
                })
    enrollment = er.find_by_name("ACADEMY 20")
    output = nil

    assert_equal output, enrollment.kindergarten_participation_in_year(2020)
  end

  def test_graduation_rate_by_year_returns_a_hash_with_years_as_keys_and_a_truncated_three_digit_floating_point
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
                      }
                })
    enrollment = er.find_by_name("ACADEMY 20")
    output ={ 2010=>0.895,
              2011=>0.895,
              2012=>0.889,
              2013=>0.913,
              2014=>0.898 }

    assert_equal output, enrollment.graduation_rate_by_year
  end

  def test_graduation_rate_in_year_returns_a_truncated_three_digit_floating_point
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
                      }
                })
    enrollment = er.find_by_name("ACADEMY 20")
    output = 0.895

    assert_equal output, enrollment.graduation_rate_in_year(2010)
  end

end
