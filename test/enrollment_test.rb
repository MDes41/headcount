require "minitest/autorun"
require "minitest/pride"
require 'pry'
require_relative "../lib/enrollment"

class EnrollmentTest < MiniTest::Test

  def test_takes_some_data
    e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    data = {kindergarten_participation: {2010 => 0.391, 2011 => 0.353, 2012 => 0.267} }

    assert_equal data[:kindergarten_participation],
    e.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_in_year_returns_nil_if_year_is_unknown
    e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    data = {kindergarten_participation: {2010 => 0.391, 2011 => 0.353, 2012 => 0.267} }

    assert_equal nil, e.kindergarten_participation_in_year(2013)
  end

  def test_kindergarten_participation_in_year
    e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    data = {kindergarten_participation: {2010 => 0.391, 2011 => 0.353, 2012 => 0.267} }

    assert_equal data[:kindergarten_participation][2010], e.kindergarten_participation_in_year(2010)
  end
end