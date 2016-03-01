equire 'pry'
require 'csv'
require_relative './district'

class EnrollmentRepository

  attr_reader :enrollments

  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  # def find_by_name(name)
  #   @enrollments.find do |enrollment|
  #     enrollment.name.upcase == name.upcase
  #   end
  # end
  #
  # def find_all_matching(name)
  #   @enrollments.find_all do |enrollment|
  #     enrollment.name.upcase.include?(name.upcase)
  #   end
  # end

end
