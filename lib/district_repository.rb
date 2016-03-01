require 'pry'
require 'csv'
require_relative './district'

class DistrictRepository

  attr_reader :districts

  def initialize(districts = [])
    @districts = districts
    @enrollments =
  end

  def create_enrollments(districts)
    districts.each do |district|
      district.enrollment = Enrollment.new(district)
    end
  end

  def find_by_name(name)
    @districts.find do |district|
      district.name.upcase == name.upcase
    end
  end

  def find_all_matching(name)
    @districts.find_all do |district|
      district.name.upcase.include?(name.upcase)
    end
  end

end
