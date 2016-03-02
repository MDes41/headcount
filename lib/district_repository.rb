require 'pry'
require 'csv'
require_relative './district'
require_relative './load_data'
require_relative './enrollment_repository'

class DistrictRepository
  attr_reader :repo, :enrollment_repo, :enrollment_object

  def initialize
    @repo = {:enrollment=>{:kindergarten=>nil}}
  end

  def load_data(hash_of_file_paths)
    @repo = LoadData.new.load_data(hash_of_file_paths)
    @enrollment_object = EnrollmentRepository.new
    @enrollment_repo = @enrollment_object.load_data(hash_of_file_paths)
  end

  def kindergarten_enrollments(repo)
    repo[:enrollment][:kindergarten]
  end

  def enrollments_grouped_by_district(repo)
    kindergarten_enrollments(repo).group_by do |enrollment|
      enrollment[:location]
    end
  end

  def district_instances_with_enrollment(repo)
    enrollments_grouped_by_district(repo).keys.map do |district|
      district_object = District.new(district)
      district_object.enrollment = enrollment_object.find_by_name(district)
      district_object
    end
  end

  def find_by_name(name)
    districts = district_instances_with_enrollment(repo)
    districts.find do |district|
      district.name.upcase == name.upcase
    end
  end

  def find_all_matching(name)
    result = []
    districts = district_instances_with_enrollment(repo)
    result = districts.find_all do |district|
      district.name.upcase.include?(name.upcase)
    end
    result
  end

end
